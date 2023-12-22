"""
Plotting Brain Images for First and Second Level Analysis of 
NMDA Practical Bistable Tactile Perception

Author: Lucy Roellecke
Last Update: December 22, 2023
"""

# %% Import
import os
from matplotlib.colors import LinearSegmentedColormap
import nibabel as nib
from nilearn import plotting

# %% Set global vars & paths >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o
tmaps_path = "/Users/Lucy/Documents/Berlin/FU/MCNB/3Semester/NMDA_Practical/analysis/"
figuredir = "/Users/Lucy/Documents/Berlin/FU/MCNB/3Semester/NMDA_Practical/figures/"

# create custom colormaps using colors from the (colorblind safe) Wong Color Palette
colors_localizer_left = [
    "#570000",
    "#730000",
    "#922500",
    "#B34200",
    "#D55E00",
]  # red colors
colormap_localizer_left = LinearSegmentedColormap.from_list(
    "cmap_localizer_left", colors_localizer_left
)
colors_localizer_right = [
    "#002B09",
    "#004523",
    "#00613C",
    "#007F57",
    "#009E73",
]  # bluish green colors
colormap_localizer_right = LinearSegmentedColormap.from_list(
    "cmap_localizer_right", colors_localizer_right
)

colors_alt = ["#4A1700", "#6A3700", "#905800", "#BA7A00", "#E69F00"]  # orange colors
colormap_alt = LinearSegmentedColormap.from_list("cmap_alt", colors_alt)
colors_sim = ["#A2E5FF", "#81C7FF", "#60AAEF", "#3D8DD0", "#0072B2"]  # blue colors
colormap_sim = LinearSegmentedColormap.from_list("cmap_sim", colors_sim)

colors_switch = [
    "#48002F",
    "#681C4B",
    "#883B68",
    "#AA5987",
    "#CC79A7",
]  # reddish purple colors
colormap_switch = LinearSegmentedColormap.from_list("cmap_switch", colors_switch)


# %% Functions >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o
def transform_tmap(tmap: str) -> nib.Nifti1Image:
    """Transform tmap to positive values."""
    # load image
    tmap_image = nib.load(tmap)
    # get image data
    tmap_data = tmap_image.get_fdata()
    # transform negative values to zero
    tmap_data[tmap_data < 0] = 0
    # create a new image with the modified data
    tmap_image_positive = nib.Nifti1Image(tmap_data, affine=tmap_image.affine)
    return tmap_image_positive


def plot_tmap(
    tmap: str,  # tmap for plotting
    display_mode: str,  # which slices to plot
    # “x”: sagittal; “y”: coronal; “z”: axial;
    # “ortho”: three cuts are performed in orthogonal direction,
    # “tiled”: three cuts are performed and arranged in a 2x2 grid
    # “mosaic”: three cuts are performed along multiple rows and columns
    threshold: float,  # significance threshold for plotting (t-value)
    cut_coords: tuple | int,  # x, y, z coordinates for mask
    cmap: str,  # colormap
    output_file: str,  # output file name
):
    """Plot tmap of fMRI contrast."""
    # plot data
    plotting.plot_stat_map(
        tmap,
        display_mode=display_mode,
        threshold=threshold,
        cut_coords=cut_coords,
        cmap=cmap,
        output_file=output_file,
    )


# %% __main__  >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o

if __name__ == "__main__":
    # %% First level analysis >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o
    # LOCALIZER --------------------------------------------------------------------
    first_level_tmap_localizer_left = os.path.join(
        tmaps_path, "1st_level/localizer/", "spmT_0004.nii"
    )
    first_level_tmap_localizer_right = os.path.join(
        tmaps_path, "1st_level/localizer/", "spmT_0005.nii"
    )

    # transform tmaps to positive values
    first_level_tmap_localizer_left_image_positive = transform_tmap(
        first_level_tmap_localizer_left
    )
    first_level_tmap_localizer_right_image_positive = transform_tmap(
        first_level_tmap_localizer_right
    )

    # plot tmaps
    plot_tmap(
        first_level_tmap_localizer_left_image_positive,
        "tiled",
        2.34,
        (70, -16, 16),
        colormap_localizer_left,
        os.path.join(figuredir, "1st_level/localizer/", "localizer_left.png"),
    )

    plot_tmap(
        first_level_tmap_localizer_right_image_positive,
        "tiled",
        2.34,
        (-54, -28, 56),
        colormap_localizer_right,
        os.path.join(figuredir, "1st_level/localizer/", "localizer_right.png"),
    )

    # PHASES --------------------------------------------------------------------
    first_level_tmap_alt = os.path.join(tmaps_path, "1st_level/model/", "spmT_0001.nii")
    first_level_tmap_sim = os.path.join(tmaps_path, "1st_level/model/", "spmT_0002.nii")

    # transform tmaps to positive values
    first_level_tmap_alt_image_positive = transform_tmap(first_level_tmap_alt)
    first_level_tmap_sim_image_positive = transform_tmap(first_level_tmap_sim)

    # plot tmaps
    plot_tmap(
        first_level_tmap_alt_image_positive,
        "tiled",
        2.33,
        (-51, -10, 53),
        colormap_alt,
        os.path.join(figuredir, "1st_level/model/", "alt.png"),
    )

    plot_tmap(
        first_level_tmap_sim_image_positive,
        "tiled",
        2.33,
        (-45, -37, 68),
        colormap_sim,
        os.path.join(figuredir, "1st_level/model/", "sim.png"),
    )

    # SWITCH --------------------------------------------------------------------
    first_level_tmap_switch = os.path.join(
        tmaps_path, "1st_level/model/", "spmT_0003.nii"
    )

    # transform tmaps to positive values
    first_level_tmap_switch_image_positive = transform_tmap(first_level_tmap_switch)

    # plot tmaps
    plot_tmap(
        first_level_tmap_switch_image_positive,
        "mosaic",
        2.33,
        3,
        colormap_switch,
        os.path.join(figuredir, "1st_level/model/", "switch.png"),
    )

    # %% Second level analysis >><< o >><< o >><< o >><< o >><< o >><< o >><< o >><< o
    # LOCALIZER --------------------------------------------------------------------
    second_level_tmap_localizer_left = os.path.join(
        tmaps_path, "2nd_level/left/", "spmT_0001.nii"
    )
    second_level_tmap_localizer_right = os.path.join(
        tmaps_path, "2nd_level/right/", "spmT_0001.nii"
    )

    # transform tmaps to positive values
    second_level_tmap_localizer_left_image_positive = transform_tmap(
        second_level_tmap_localizer_left
    )
    second_level_tmap_localizer_right_image_positive = transform_tmap(
        second_level_tmap_localizer_right
    )

    # plot tmaps
    plot_tmap(
        second_level_tmap_localizer_left_image_positive,
        "tiled",
        2.90,
        (54, -36, 18),
        colormap_localizer_left,
        os.path.join(figuredir, "2nd_level/localizer/", "localizer_left.png"),
    )

    plot_tmap(
        second_level_tmap_localizer_right_image_positive,
        "tiled",
        2.90,
        (-46, -8, 5),
        colormap_localizer_right,
        os.path.join(figuredir, "2nd_level/localizer/", "localizer_right.png"),
    )

    # PHASES --------------------------------------------------------------------
    second_level_tmap_alt = os.path.join(tmaps_path, "2nd_level/a-s/", "spmT_0001.nii")
    second_level_tmap_sim = os.path.join(tmaps_path, "2nd_level/s-a/", "spmT_0001.nii")

    # transform tmaps to positive values
    second_level_tmap_alt_image_positive = transform_tmap(second_level_tmap_alt)
    second_level_tmap_sim_image_positive = transform_tmap(second_level_tmap_sim)

    # plot tmaps
    plot_tmap(
        second_level_tmap_alt_image_positive,
        "tiled",
        2.90,
        (22, -14, 54),
        colormap_alt,
        os.path.join(figuredir, "2nd_level/model/", "alt.png"),
    )

    plot_tmap(
        second_level_tmap_sim_image_positive,
        "tiled",
        2.90,
        (56, 6, 44),
        colormap_sim,
        os.path.join(figuredir, "2nd_level/model/", "sim.png"),
    )

    # SWITCH --------------------------------------------------------------------
    second_level_tmap_switch = os.path.join(
        tmaps_path, "2nd_level/switch/", "spmT_0001.nii"
    )

    # transform tmaps to positive values
    second_level_tmap_switch_image_positive = transform_tmap(second_level_tmap_switch)

    # plot tmaps
    plot_tmap(
        second_level_tmap_switch_image_positive,
        "mosaic",
        2.90,
        3,
        colormap_switch,
        os.path.join(figuredir, "2nd_level/model/", "switch.png"),
    )
