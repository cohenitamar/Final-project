const statsService = require('../services/statsService')


async function addStats(req, res) {

    const uid = req.user.uid;
    const stat = req.body
    try {
        let result = await statsService.addStats(uid, stat);
        if (result === -1) {
            return res.status(404).json("Error");
        }
        else{
            return res.json(200);
        }

    } catch (error) {
        return res.status(404).json("Error");
    }


}

async function updateAchievements(req, res) {
    const uid = req.user.uid;
    const achievements = req.body
    var result;
    try {

        result = await statsService.updateAchievements(uid, achievements);
        if (result === -1) {
            return res.status(404).json("Error");
        } else {
            return res.json(200);
        }


    } catch (error) {
        return res.status(404).json("Error");
    }


}


async function getStats(req, res) {

    let result;
    try {
        result = await statsService.getStats(req.user.uid);
        if (result === -1) {
            return res.status(404).json("Error");
        }
        return res.json(result);

    } catch (error) {
        return res.status(404).json("Error");
    }

}


module.exports = {getStats, addStats, updateAchievements}
