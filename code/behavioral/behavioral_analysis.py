"""
Behavioral Analysis for NMDA Practical Bistable Tactile Perception

Author: Lucy Roellecke
Last Update: December 16, 2023
"""

# %% Import
import os
import numpy as np
import pandas as pd
import pingouin as pg
import matplotlib.pyplot as plt
import seaborn as sns

# %% Set global vars & paths >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o
datapath = "/Users/Lucy/Documents/Berlin/FU/MCNB/3Semester/NMDA_Practical/data/"
datafile = os.path.join(datapath, "BTAPE-Group-Data.csv")
resultpath = (
    "/Users/Lucy/Documents/Berlin/FU/MCNB/3Semester/NMDA_Practical/analysis/behavioral/"
)
figuredir = (
    "/Users/Lucy/Documents/Berlin/FU/MCNB/3Semester/NMDA_Practical/figures/behavioral/"
)

subjects = [
    "sub-001",
    "sub-002",
    "sub-003",
    "sub-004",
    "sub-005",
    "sub-006",
    "sub-007",
    "sub-008",
    "sub-009",
]

runs = ["1", "2", "3", "4", "5", "6"]


# %% Functions >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o
def calculate_anova(
    data: pd.DataFrame,  # data for anova
    dependent_variable: str,  # dependent variable in dataframe
    subjects: str,  # subject variable in dataframe
    within_factor: list[str],  # (list of) within factor(s) in dataframe
) -> pd.DataFrame:
    """Calculate repeated measures ANOVA for data."""
    # calculate rm anova
    results = pg.rm_anova(
        dv=dependent_variable,
        within=within_factor,
        subject=subjects,
        data=data,
        detailed=True,
    )

    # calculate post-hoc tests
    post_hocs = pg.pairwise_ttests(
        dv=dependent_variable,
        within=within_factor,
        subject=subjects,
        padjust="fdr_bh",
        data=data,
    )

    return results, post_hocs


def check_assumptions(
    data: pd.DataFrame, dependent_variable: str, subjects: str, within_factor: list[str]
) -> pd.DataFrame:
    """Check assumptions for ANOVA."""
    # sphericity
    sphericity_results = pg.sphericity(
        data=data, dv=dependent_variable, subject=subjects, within=within_factor
    )
    # normality of related groups (switches)
    normality_results = pg.normality(
        data=data, dv=dependent_variable, group=within_factor[1]
    )
    return sphericity_results, normality_results


def plot_results(
    data: pd.DataFrame,  # data for plotting
    x: str,  # x-axis variable
    y: str,  # y-axis variable
    hue: str,  # hue variable
) -> plt.figure:
    """Plot results."""
    # plot data
    color_palette_boxes = ["#E69F00", "#56B4E9"]
    color_palette_points = ["#D55E00", "#0072B2"]
    figure, axes = plt.subplots(figsize=(5, 4))
    sns.boxplot(
        data=data, x=x, y=y, hue=hue, palette=color_palette_boxes, ax=axes, fliersize=0
    )
    sns.stripplot(data=data, x=x, y=y, palette=color_palette_points, ax=axes)
    # set labels of legend
    handles, labels = axes.get_legend_handles_labels()
    axes.legend(handles=handles, labels=["Alternating", "Simultaneous"])
    # set xtick labels
    axes.set_xticklabels(["Alternating", "Simultaneous"])
    # show plot
    # plt.show()
    return figure


# %% __main__  >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o

if __name__ == "__main__":
    # read in csv file
    data = pd.read_csv(datafile)

    # calculate mean and std of age
    age_mean = np.mean(data["Age"])
    age_std = np.std(data["Age"])

    # calculate mean and std of EDI
    edi_mean = np.mean(data["EDI"])
    edi_std = np.std(data["EDI"])

    # create lists for variables
    age_all = list(data["Age"])
    age_all.append(age_mean)
    age_all.append(age_std)
    edi_all = list(data["EDI"])
    edi_all.append(edi_mean)
    edi_all.append(edi_std)
    subject_all = list(data["f"])
    subject_all.append("Mean")
    subject_all.append("Std")
    sex_all = list(data["Sex"])
    sex_all.append("")
    sex_all.append("")

    # add descriptives to dataframe
    data_descriptives = pd.DataFrame(
        {"Subject": subject_all, "Age": age_all, "Sex": sex_all, "EDI": edi_all}
    )

    # export descriptives to csv
    data_descriptives.to_csv(os.path.join(resultpath, "descriptives.csv"))

    # format data for anova
    # create empty dataframe
    anova_data = pd.DataFrame(
        {"Subject": [], "Run": [], "Switch To": [], "Number of Blinks": []}
    )

    # loop through subjects
    for index, subject in enumerate(subjects):
        # get subject data
        subject_data = data[data["f"] == subject]
        # loop through runs
        for row, run in enumerate(runs):
            # get run value (switch to alternating)
            run_value_alt = subject_data[f"A{run}"][index]
            # get run value (switch to simultaneous)
            run_value_sim = subject_data[f"S{run}"][index]

            # add values to dataframe
            row_index = index * 2 * len(runs) + row * 2
            anova_data.loc[row_index, "Subject"] = subject
            anova_data.loc[row_index + 1, "Subject"] = subject
            anova_data.loc[row_index, "Run"] = run
            anova_data.loc[row_index + 1, "Run"] = run
            anova_data.loc[row_index, "Switch To"] = 1  # alternating
            anova_data.loc[row_index + 1, "Switch To"] = 2  # simultaneous
            anova_data.loc[row_index, "Number of Blinks"] = run_value_alt
            anova_data.loc[row_index + 1, "Number of Blinks"] = run_value_sim

    # sort data by subject number
    anova_data = anova_data.sort_values(by=["Subject", "Run"])

    # export anova data to csv
    anova_data.to_csv(os.path.join(resultpath, "rm_anova_data.csv"))

    # check assumptions for anova
    sphericity_results, normality_results = check_assumptions(
        anova_data, "Number of Blinks", "Subject", ["Run", "Switch To"]
    )
    # turn results into dataframe
    sphericity_results_list = list(sphericity_results)
    sphericity_results_dict = {
        "W": str(sphericity_results_list[1]),
        "chi2": str(sphericity_results_list[2]),
        "dof": str(sphericity_results_list[3]),
        "pval": str(sphericity_results_list[4]),
        "spher": str(sphericity_results_list[0]),
    }
    sphericity_results_dataframe = pd.DataFrame(sphericity_results_dict, index=[0])
    assumptions_results = pd.concat(
        [sphericity_results_dataframe, normality_results], axis=1
    )
    # add a column with assumption names
    assumptions_results["Assumption"] = ["Sphericity", "Normality", "Normality"]
    # export assumptions results to csv
    assumptions_results.to_csv(os.path.join(resultpath, "rm_anova_assumptions.csv"))

    # calculate anova
    anova_results, post_hocs = calculate_anova(
        anova_data, "Number of Blinks", "Subject", ["Run", "Switch To"]
    )

    # export anova results to csv
    anova_results.to_csv(os.path.join(resultpath, "rm_anova_results.csv"))
    post_hocs.to_csv(os.path.join(resultpath, "rm_anova_post_hocs.csv"))

    # add descriptives to dataframe
    anova_data.loc[row_index + 2, "Run"] = "Mean"
    anova_data.loc[row_index + 3, "Run"] = "Mean"
    anova_data.loc[row_index + 2, "Switch To"] = 1  # alternating
    anova_data.loc[row_index + 3, "Switch To"] = 2  # simultaneous
    anova_data.loc[row_index + 2, "Number of Blinks"] = np.mean(
        anova_data["Number of Blinks"][anova_data["Switch To"] == 1]
    )
    anova_data.loc[row_index + 3, "Number of Blinks"] = np.mean(
        anova_data["Number of Blinks"][anova_data["Switch To"] == 2]
    )
    anova_data.loc[row_index + 4, "Run"] = "Std"
    anova_data.loc[row_index + 5, "Run"] = "Std"
    anova_data.loc[row_index + 4, "Switch To"] = 1  # alternating
    anova_data.loc[row_index + 5, "Switch To"] = 2  # simultaneous
    anova_data.loc[row_index + 4, "Number of Blinks"] = np.std(
        anova_data["Number of Blinks"][anova_data["Switch To"] == 1]
    )
    anova_data.loc[row_index + 5, "Number of Blinks"] = np.std(
        anova_data["Number of Blinks"][anova_data["Switch To"] == 2]
    )

    # export descriptive statistics to csv
    anova_data.to_csv(os.path.join(resultpath, "descriptives_data.csv"))

    # plot anova results
    anova_figure = plot_results(
        anova_data, "Switch To", "Number of Blinks", "Switch To"
    )

    # save plot to file
    anova_figure.savefig(os.path.join(figuredir, "anova_results.pdf"))

    # close plot
    plt.close()

# o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o END
