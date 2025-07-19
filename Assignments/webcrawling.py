import os
import requests
from bs4 import BeautifulSoup
from PIL import Image
from concurrent.futures import ThreadPoolExecutor

# ------------- Global Variables -------------
START_URL = "https://www.bodybuilding.com/exercises/"  # The starting URL for crawling exercise pages
ROOT_FOLDER = None  # Will be set to the "dataset" folder path in main()
ASSET_PATHS = []  # Collects relative paths to generated assets for final output in pubspec.yaml


# ------------- Utility Functions -------------
def create_dataset_folder():
    """
    Creates (or ensures the existence of) the main 'dataset' folder
    in the same directory as this script.
    Returns:
        The absolute path to that 'dataset' folder.
    """
    # Get the absolute directory path of this script
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Construct the path to the "dataset" folder within this script's directory
    dataset_folder = os.path.join(script_dir, "dataset")

    # Create the folder if it doesn't exist (no error if it already exists)
    os.makedirs(dataset_folder, exist_ok=True)

    # Return the absolute path to the dataset folder
    return dataset_folder


def is_valid_image(file):
    """
    Checks if the given file name indicates an image we want to use for GIF creation.
    We look for files that start with 'image_' and end with '.jpg'.
    """
    return file.startswith("image_") and file.endswith(".jpg")


def process_muscle_gp(muscle_gp):
    """
    Processes the muscle group text to maintain consistent naming conventions.
    Converts "lower back" to "LowerBack", "middle back" to "MiddleBack",
    and replaces spaces in other muscle group names with underscores.
    """
    # Check for 'lower back' (case-insensitive) and convert accordingly
    if muscle_gp.lower() == 'lower back':
        return 'LowerBack'
    # Check for 'middle back' (case-insensitive) and convert accordingly
    elif muscle_gp.lower() == 'middle back':
        return 'MiddleBack'
    else:
        # For any other muscle group, replace spaces with underscores
        return muscle_gp.replace(' ', '_')


# ------------- Web-Crawling -------------
def get_exercise_links():
    """
    From the START_URL, crawls the site to collect all exercise page URLs.
    Depending on the site's structure, you might need to handle pagination.
    For now, we'll parse a single page or a standard listing approach.

    Returns:
        A list of exercise page URLs (strings).
    """
    print(f"Crawling the exercises directory: {START_URL}")

    # Make an HTTP GET request to the starting URL
    response = requests.get(START_URL)

    # Parse the HTML content with BeautifulSoup
    soup = BeautifulSoup(response.content, "html.parser")

    # Attempt to find the div that contains the exercise results
    exercises_section = soup.find("div", class_="ExCategory-results")
    if not exercises_section:
        print("Could not find exercises section. Check site structure.")
        return []

    # Find all 'a' tags with class "ExResult-row--name" inside that section
    links = exercises_section.find_all("a", class_="ExResult-row--name")

    # Initialize a list to store the full URLs to each exercise
    exercise_urls = []

    # Loop through each <a> tag found
    for link in links:
        # Extract the value of the 'href' attribute
        href = link.get("href")

        # Some links might be relative, so ensure we build a full URL
        if href and href.startswith("/"):
            href = "https://www.bodybuilding.com" + href

        # If href is valid, add to our list of exercise URLs
        if href:
            exercise_urls.append(href)

    print(f"Found {len(exercise_urls)} exercise links.")
    return exercise_urls


# ------------- Scraping Each Exercise Page -------------
def process_exercise_page(exercise_url):
    """
    Given a single exercise URL, scrape the page for:
        - Exercise name
        - Muscle group
        - Image links
        - Instructions
        - Muscle GIF link (optional)

    Returns:
        A dictionary with keys:
            "exercise_name", "muscle_gp", "image_urls",
            "instructions", "gif_url".
    """
    print(f"Scraping exercise page: {exercise_url}")

    # Make an HTTP GET request for the exercise page
    response = requests.get(exercise_url)

    # Parse the HTML content
    soup = BeautifulSoup(response.content, "html.parser")

    # ----- Extract exercise name -----
    # This is often in an <h1> or <h2> with a specific class
    name_tag = soup.find("h1", class_="ExHeading ExHeading--h2")

    # If we found the name tag, get the text; otherwise, label it as unknown
    exercise_name = name_tag.get_text(strip=True) if name_tag else "Unknown_Exercise"

    # Replace slashes in the name to prevent file path issues
    exercise_name = exercise_name.replace("/", "_")

    # ----- Extract muscle group -----
    # This might be listed in a specific div with class "ExDetail-muscleTargeted"
    muscle_gp = "Unknown"
    muscle_tag = soup.find("div", class_="ExDetail-muscleTargeted")
    if muscle_tag:
        muscle_gp = muscle_tag.get_text(strip=True)
    # Also replace slashes just in case
    muscle_gp = muscle_gp.replace("/", "_")

    # ----- Extract images (for the "Photos" section) -----
    # Typically, the site might have them in a section with class "ExDetail-photos"
    photos_section = soup.find("section", class_="ExDetail-section ExDetail-photos paywall__xdb-details")
    image_urls = []
    if photos_section:
        # Find all <img> tags in the photos section
        images = photos_section.find_all("img")
        for img in images:
            src = img.get("src")
            # Only append valid HTTP URLs
            if src and src.startswith("http"):
                image_urls.append(src)

    # ----- Extract instructions (for the "Guide" section) -----
    # Typically, instructions might be in <ol> elements under a section with class "ExDetail-guide"
    guide_section = soup.find("section", class_="ExDetail-section ExDetail-guide")
    instructions_list = []
    if guide_section:
        # Find all <ol> tags inside the guide section
        ol_tags = guide_section.find_all("ol")

        # For each ordered list, get the <li> items and build instructions
        for ol in ol_tags:
            li_tags = ol.find_all("li")
            for idx, li in enumerate(li_tags, start=1):
                # Combine the line number and the text (strip whitespace)
                instructions_list.append(f"{idx}. {li.get_text(strip=True)}")

    # ----- Extract muscle GIF (if available) -----
    gif_url = None
    if guide_section:
        # Sometimes there's an <img> that might be a .gif indicating targeted muscles
        gif_tag = guide_section.find("img")
        if gif_tag:
            possible_gif_url = gif_tag.get("src")
            # Check if the src ends with .gif
            if possible_gif_url and possible_gif_url.endswith(".gif"):
                gif_url = possible_gif_url

    # Return the collected data in a dictionary
    return {
        "exercise_name": exercise_name,
        "muscle_gp": muscle_gp,
        "image_urls": image_urls,
        "instructions": instructions_list,
        "gif_url": gif_url
    }


# ------------- Download & File Creation -------------
def download_images(exercise_folder, image_urls):
    """
    Downloads images from the provided URLs to the given folder,
    saving them as image_1.jpg, image_2.jpg, etc.

    Args:
        exercise_folder (str): The path to the folder for this exercise.
        image_urls (list): List of image URLs to download.
    """
    # Loop through all image URLs
    for i, img_url in enumerate(image_urls):
        try:
            # Retrieve the image data via an HTTP GET
            img_data = requests.get(img_url).content

            # Construct a path for this image file in the exercise folder
            image_path = os.path.join(exercise_folder, f"image_{i + 1}.jpg")

            # Write the image data to disk in binary mode
            with open(image_path, "wb") as f:
                f.write(img_data)

            print(f"Downloaded: {img_url} -> {image_path}")
        except Exception as e:
            print(f"Could not download {img_url}. Error: {e}")


def create_gif_for_folder(exercise_folder, exercise_name, muscle_gp):
    """
    Collects all 'image_*.jpg' files in the folder, sorts them,
    creates both a full-size GIF and a smaller 246x228 GIF, saves them,
    and then deletes the source images afterward.

    Args:
        exercise_folder (str): The path to the folder for this exercise.
        exercise_name (str): The name of the exercise.
        muscle_gp (str): The muscle group targeted by the exercise.
    """
    # Convert any variant of muscle group naming to a consistent format
    exercise_name_safe = exercise_name.replace(" ", "_")
    muscle_gp_safe = process_muscle_gp(muscle_gp)

    # Find all jpg files that match our naming scheme ("image_*.jpg")
    image_files = [f for f in os.listdir(exercise_folder) if is_valid_image(f)]

    # Sort them to ensure they are in ascending order (image_1, image_2, etc.)
    image_files.sort()

    # If no images are found, just exit the function
    if not image_files:
        print(f"No images found to create GIFs for {exercise_name}.")
        return

    # Load each found image using PIL and store them in a list
    image_list = [Image.open(os.path.join(exercise_folder, f)) for f in image_files]

    # 1) Create the full-size GIF
    resized_full = []
    for img in image_list:
        width, height = img.size
        # If the image is wider than 512px, resize to 512px width (maintaining aspect ratio)
        if width > 512:
            new_height = int((512 / width) * height)
            img_resized = img.resize((512, new_height), Image.LANCZOS)
        else:
            # Otherwise, keep it as is (but still make a copy)
            img_resized = img.copy()
        resized_full.append(img_resized)

    # Name for the full-size GIF, including muscle group and exercise name
    full_gif_name = f"{muscle_gp_safe}_{exercise_name_safe}_fullsize.gif"
    # Build the complete path to save this GIF
    full_gif_path = os.path.join(exercise_folder, full_gif_name)

    # Save the first image, then append the rest
    resized_full[0].save(
        full_gif_path,
        save_all=True,
        append_images=resized_full[1:],
        duration=500,  # 500ms per frame
        loop=0  # 0 means infinite loop
    )
    print(f"Full-size GIF created: {full_gif_path}")

    # Add the created GIF path to our global list (relative path, not absolute)
    ASSET_PATHS.append(os.path.relpath(full_gif_path, start=os.path.dirname(__file__)))

    # 2) Create the small-size GIF (246x228)
    resized_small = []
    for img in image_list:
        # Regardless of original size, resize to 246x228
        img_small = img.resize((246, 228), Image.LANCZOS)
        resized_small.append(img_small)

    # Name for the small-size GIF
    small_gif_name = f"{muscle_gp_safe}_{exercise_name_safe}.gif"
    # Build the complete path
    small_gif_path = os.path.join(exercise_folder, small_gif_name)

    # Save the small GIF
    resized_small[0].save(
        small_gif_path,
        save_all=True,
        append_images=resized_small[1:],
        duration=500,
        loop=0
    )
    print(f"Small-size GIF created: {small_gif_path}")

    # Add the small GIF path to our global list (relative path, not absolute)
    ASSET_PATHS.append(os.path.relpath(small_gif_path, start=os.path.dirname(__file__)))

    # Remove the source images after the GIFs are created
    for f in image_files:
        os.remove(os.path.join(exercise_folder, f))
        print(f"Deleted: {f}")


def download_muscle_gif(exercise_folder, gif_url):
    """
    Downloads the muscle GIF (if any exists), converts it to JPG,
    deletes the original GIF, and updates the ASSET_PATHS with the JPG path.

    Args:
        exercise_folder (str): The path to the folder for this exercise.
        gif_url (str or None): The URL of the muscle GIF (could be None if unavailable).
    """
    # If there's no muscle GIF URL, just return
    if not gif_url:
        return

    try:
        # Download the GIF data
        gif_data = requests.get(gif_url).content

        # Construct file paths for the GIF and the converted JPG
        gif_path = os.path.join(exercise_folder, "muscles.gif")
        jpg_path = os.path.join(exercise_folder, "muscles.jpg")

        # Save the original GIF
        with open(gif_path, "wb") as f:
            f.write(gif_data)
        print(f"Downloaded muscle GIF -> {gif_path}")

        # Open the GIF with PIL, convert it to RGB, and save as JPG
        with Image.open(gif_path) as img:
            img.convert("RGB").save(jpg_path, "JPEG", quality=100)
        print(f"Converted '{gif_path}' to '{jpg_path}'")

        # Add the JPG path to our global asset list (relative path)
        ASSET_PATHS.append(os.path.relpath(jpg_path, start=os.path.dirname(__file__)))

        # Remove the original GIF file
        os.remove(gif_path)

    except Exception as e:
        print(f"Could not download/convert muscle GIF. Error: {e}")


def save_instructions(exercise_folder, instructions):
    """
    Saves the exercise instructions to a file named 'instructions.txt' in the exercise folder.

    Args:
        exercise_folder (str): The path to the folder for this exercise.
        instructions (list): A list of instruction steps (strings).
    """
    # Construct the path to the instructions file
    instructions_path = os.path.join(exercise_folder, "instructions.txt")

    # Write each instruction step to the file, separated by newlines
    with open(instructions_path, "w", encoding="utf-8") as f:
        f.write("\n".join(instructions))
    print(f"Saved instructions -> {instructions_path}")

    # Add the path to our global asset list (relative path)
    ASSET_PATHS.append(os.path.relpath(instructions_path, start=os.path.dirname(__file__)))


# ------------- Main Orchestrator -------------
def process_single_exercise(exercise_url):
    """
    The thread-safe function called by ThreadPoolExecutor to handle
    the entire scraping and asset creation for one exercise.

    Args:
        exercise_url (str): The URL of the exercise page to process.
    """
    # 1) Scrape the exercise page for data
    data = process_exercise_page(exercise_url)

    # Extract the relevant data from the returned dictionary
    exercise_name = data["exercise_name"]
    muscle_gp = data["muscle_gp"]
    image_urls = data["image_urls"]
    instructions = data["instructions"]
    gif_url = data["gif_url"]

    # 2) Create a folder for the exercise within the dataset folder
    exercise_folder_name = exercise_name.replace(" ", "_")
    exercise_folder = os.path.join(ROOT_FOLDER, exercise_folder_name)

    # Ensure the folder exists
    os.makedirs(exercise_folder, exist_ok=True)

    # 3) Download the images for this exercise
    download_images(exercise_folder, image_urls)

    # 4) Create GIFs from the downloaded images (if any were downloaded)
    create_gif_for_folder(exercise_folder, exercise_name, muscle_gp)

    # 5) Download the muscle group GIF and convert it to JPG (if available)
    download_muscle_gif(exercise_folder, gif_url)

    # 6) Save the instructions to a text file
    save_instructions(exercise_folder, instructions)


def main():
    """
    Main function that orchestrates:
    1) Creating/ensuring the dataset folder
    2) Getting all exercise links via `get_exercise_links()`
    3) Using a ThreadPoolExecutor to process each exercise link in parallel
    4) Printing out the relative paths to generated assets for usage in pubspec.yaml
    """
    # Make the global ROOT_FOLDER accessible
    global ROOT_FOLDER

    # Create (or get) the dataset folder path and store it
    ROOT_FOLDER = create_dataset_folder()

    # 1) Collect all exercise links from the start URL
    exercise_links = get_exercise_links()

    # 2) Use ThreadPoolExecutor to process each exercise link in parallel for efficiency
    with ThreadPoolExecutor(max_workers=12) as executor:
        executor.map(process_single_exercise, exercise_links)

    # Once all exercises are processed, print a summary message
    print("\n--- All exercises processed successfully! ---\n")
    print("Add the following lines under the 'assets:' section in your pubspec.yaml:\n")

    # Print out each asset path for easy copy-pasting into pubspec.yaml
    for path in ASSET_PATHS:
        print(f"  - {path}")


# If this script is the entry point, run main()
if __name__ == "__main__":
    main()
