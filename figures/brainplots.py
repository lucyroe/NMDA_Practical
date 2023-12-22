from nilearn import plotting


# -----------------------------------------
#  Switch 3 reg
# -----------------------------------------


# Path to spm T-stats map 
spm_tmap_c1 = './results/1stlevel_switch_3reg/spmT_0001.nii'
spm_tmap_c2 = './results/1stlevel_switch_3reg//spmT_0002.nii'
spm_tmap_c3 = './results/1stlevel_switch_3reg//spmT_0003.nii'

# Glas brain
plotting.plot_glass_brain(spm_tmap_c1, display_mode="lyrz", threshold=3)
plotting.plot_glass_brain(spm_tmap_c2, display_mode="lyrz", threshold=3)
plotting.plot_glass_brain(spm_tmap_c3, display_mode="lyrz", threshold=3)

# Slices 
plotting.plot_stat_map(spm_tmap_c1, display_mode='z', threshold=3.,
                       cut_coords=range(0, 51, 10)) # title='Slices'

plotting.plot_stat_map(spm_tmap_c2, display_mode='z', threshold=3.,
                       cut_coords=range(0, 51, 10)) # title='Slices'

plotting.plot_stat_map(spm_tmap_c3, display_mode='z', threshold=3.,
                       cut_coords=range(0, 51, 10)) # title='Slices'



# -----------------------------------------
# Localizer 
# -----------------------------------------

spm_tmap_c1 = './results/1stlevel_localizer/spmT_0001.nii' # check contrasts
spm_tmap_c2 = './results/1stlevel_localizer/spmT_0002.nii' # check contrasts
spm_tmap_c3 = './results/1stlevel_localizer/spmT_0003.nii'  # check contrasts 

# Glas brain
plotting.plot_glass_brain(spm_tmap_c1, display_mode="lyrz", threshold=3)
plotting.plot_glass_brain(spm_tmap_c2, display_mode="lyrz", threshold=3)
plotting.plot_glass_brain(spm_tmap_c3, display_mode="lyrz", threshold=3)

# Slices 
plotting.plot_stat_map(spm_tmap_c1, display_mode='z', threshold=3.,
                       cut_coords=range(0, 51, 10)) # title='Slices'

plotting.plot_stat_map(spm_tmap_c2, display_mode='z', threshold=3.,
                       cut_coords=range(0, 51, 10)) # title='Slices'

plotting.plot_stat_map(spm_tmap_c3, display_mode='z', threshold=3.,
                       cut_coords=range(0, 51, 10)) # title='Slices'
