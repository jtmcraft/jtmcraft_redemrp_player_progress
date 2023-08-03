new Muuri('.grid');

const numberFormatter = new Intl.NumberFormat();

const percentage = (numerator, denominator) => {
    if (denominator === 0) {
        return "--";
    }

    const p = parseFloat((numerator / denominator) * 100.0).toFixed(2);
    return p;
};

const metersToFeet = (meters) => {
    const feet = parseFloat(meters) * 3.2808399;
    return feet.toFixed(2);
};

window.onload = (e) => {
    const body = $('#progress-body');
    body.hide();

    const populatePistolKills = (pistolKillsData) => {
        const totalKills = parseInt(pistolKillsData?.total?.kills || 0);
        // const longestShot = parseFloat(pistolKillsData?.total?.longestShot || 0);
        const pistolKills = parseInt(pistolKillsData?.pistol?.kills || 0);
        const pistolKillsPercentage = percentage(pistolKills, totalKills);
        const pistolLongestShotMeters = parseFloat(pistolKillsData?.pistol?.longestShot || 0);
        const pistolLongestShotFeet = metersToFeet(pistolLongestShotMeters);

        $('#pistol-kills-content').text(numberFormatter.format(pistolKills));
        $('#pistol-kills-content-percentage').text(numberFormatter.format(pistolKillsPercentage));

        $('#pistol-kills-longest-shot-content-meters').text(numberFormatter.format(pistolLongestShotMeters));
        $('#pistol-kills-longest-shot-content-feet').text(numberFormatter.format(pistolLongestShotFeet));
    }

    const populateKills = (kills) => {
        const totalKills = parseInt(kills?.totalKills || 0);
        const executions = parseInt(kills?.executions || 0);
        const executionsPercentage = percentage(executions, totalKills);
        const fromHip = parseInt(kills?.fromHip || 0);
        const fromHipPercentage = percentage(fromHip, totalKills);
        const fromHorse = parseInt(kills?.fromHorse || 0);
        const fromHorsePercentage = percentage(fromHorse, totalKills);
        const headShots = parseInt(kills?.headShots || 0);
        const headShotsPercentage = percentage(headShots, totalKills);
        const melee = parseInt(kills?.melee || 0);
        const meleePercentage = percentage(melee, totalKills)
        const longestShotMeters = parseFloat(kills?.longestShot || 0);
        const longestShotFeet = metersToFeet(longestShotMeters);

        $('#kills-total-content').text(numberFormatter.format(totalKills));
        $('#kills-executions-content').text(numberFormatter.format(executions));
        $('#kills-executions-content-percentage').text(numberFormatter.format(executionsPercentage));
        $('#kills-from-hip-content').text(numberFormatter.format(fromHip));
        $('#kills-from-hip-content-percentage').text(numberFormatter.format(fromHipPercentage));
        $('#kills-from-horse-content').text(numberFormatter.format(fromHorse));
        $('#kills-from-horse-content-percentage').text(numberFormatter.format(fromHorsePercentage));
        $('#kills-head-shots-content').text(numberFormatter.format(headShots));
        $('#kills-head-shots-content-percentage').text(numberFormatter.format(headShotsPercentage));
        $('#kills-melee-content').text(numberFormatter.format(melee));
        $('#kills-melee-content-percentage').text(numberFormatter.format(meleePercentage));
        $('#kills-longest-shot-content-meters').text(numberFormatter.format(longestShotMeters));
        $('#kills-longest-shot-content-feet').text(numberFormatter.format(longestShotFeet));
    }

    window.addEventListener('message', (event) => {
        if (event.data.showProgress === true) {

            const { kills } = event.data;
            populateKills(kills);

            const { pistolKills } = event.data;
            populatePistolKills(pistolKills);

            body.show();
        } else {
            body.hide();
        }
    });
};
