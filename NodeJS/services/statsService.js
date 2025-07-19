const Achievement = require("../models/Achievements").model;
const Users = require('../models/Users').model;
const Progress = require('../models/Progress').model;
const History = require('../models/History').model;

async function getStats(userID) {
    try {
        var user = await Users.findOne({'_id': userID});
        await user.populate('history');
        await user.populate('progress');
        return {
            history: user['history'],
            progress: user['progress']
        }
    } catch (e) {
        return -1;
    }
}

async function addStats(userID, stat) {
    const user = await Users.findOne({'_id': userID});
    const res1 = await addHistory(user, stat.history[0]);
    const res2 = await addProgress(user, stat);
    if (res2 === -1 || res1 ===-1){
        return -1;
    }
    return 1;



}


async function addHistory(user, stat) {
    try {
        const newHistory = new History({
                userID: user['_id'],
                title: stat.title,
                executionDate: stat.executionDate,
                duration: stat.duration,
                exercises: stat.exercises,
            }
        )
        const savedHistory = await newHistory.save();
        user['history'].push(savedHistory['_id']);
        user.save();
        return savedHistory;

    } catch (error) {
        return -1;
    }
}


async function updateAchievements(userID, achievements){

    try {
        const achievement = await Achievement.findByIdAndUpdate(achievements['_id'],
            {
                userID: userID,
                maxWeight: achievements.maxWeight,
                highestReps: achievements.highestReps,
                longestWorkoutDuration: achievements.longestWorkoutDuration,
                lowestBodyFatPercent: achievements.lowestBodyFatPercent,
                totalWorkouts: achievements.totalWorkouts,
                totalWeightLifted: achievements.totalWeightLifted,
                totalReps: achievements.totalReps,
                activeDays: achievements.activeDays,
                lastActiveDay: achievements.lastActiveDay,
                totalWorkoutDuration: achievements.totalWorkoutDuration,
                longestWorkoutStreak: achievements.longestWorkoutStreak,
                lastDayOfStreak: achievements.lastDayOfStreak
            },
            {new: true}
        );

        return achievement;
    }
    catch(error){
        return -1;
    }
}


async function addProgress(user, stat) {
    try {
        for (const exercise of stat.exercise) {
            if (!exercise.checked) {
                continue;
            }
            ///TODO IF POPULATE CAN BE USED AND IT WILL BE SHORTER TIME OF EXECUTION THEN WE NEED TO CHANGE IT
            ///TODO ALSO TO MAKE TRANSACTIONS IN THE DB
            var progress = await Progress.findOne({userID: user['_id'], exercise: exercise.name});
            var isProgress = progress ? true : false;
            if (progress) {
                // Find the index of the current week in dataByWeek
                const weekIndex = progress.dataByWeek.findIndex(
                    (weekData) => weekData.week === stat.week && weekData.year === stat.year
                );
                if (weekIndex !== -1) {
                    // Add new dataByDate to existing week
                    progress.dataByWeek[weekIndex].dataByDate.push({
                        exerciseDetails: {
                            reps: exercise.exerciseDetails.reps,
                            sets: exercise.exerciseDetails.sets,
                            weight: exercise.exerciseDetails.weight,
                        },
                        date: stat.date,
                    });
                } else {
                    // Add a new week with dataByDate
                    progress.dataByWeek.push({
                        week: stat.week,
                        year: stat.year,
                        dataByDate: [
                            {
                                exerciseDetails: {
                                    reps: exercise.exerciseDetails.reps,
                                    sets: exercise.exerciseDetails.sets,
                                    weight: exercise.exerciseDetails.weight,
                                },
                                date: stat.date,
                            },
                        ],
                    });
                }
            } else {
                // Create new progress document for the exercise
                progress = new Progress({
                    userID: user['_id'],
                    exercise: exercise.name,
                    dataByWeek: [
                        {
                            week: stat.week,
                            year: stat.year,
                            dataByDate: [
                                {
                                    exerciseDetails: {
                                        reps: exercise.exerciseDetails.reps,
                                        sets: exercise.exerciseDetails.sets,
                                        weight: exercise.exerciseDetails.weight,
                                    },
                                    date: stat.date,
                                },
                            ],
                        },
                    ],
                });
            }
            progress.markModified('dataByExercise');
            var savedProgress = await progress.save();
            if (!isProgress) {
                user['progress'].push(savedProgress['_id']);
                user.save();
            }
        }
        return savedProgress;

    } catch (error) {
        return -1;
    }
}


module.exports = {getStats, addStats,updateAchievements}





