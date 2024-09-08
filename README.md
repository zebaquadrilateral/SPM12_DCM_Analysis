Exploring Perception and Imagination of Tactile Stimulation in the Somatosensory and Motor Cortex
Department of Education and Psychology, Freie Universität Berlin
 ERZPSY_S_127041_24S: Probabilistic and Statistical Modelling
 Dr. Ryszard Auksztulewicz
 14th of August, 2024
Zeba Quadri/ Effective Connectivity: First-level dynamic causal modeling (DCM)
 DCMModels were Specified, Estimated and Compared for every subject using SPM12. The bar
 graph for parameter estimates was created with Matlab. First-level specification is based of
 (Zeidman et al., 2019). The scripts for DCM model specification, estimation and comparison can
 be found in the repository along with the script for bar plot of the parameter estimates (see
 ‘03-dcm-first-level’)
 Exploring Perception and Imagination of Tactile Stimulation in the Somatosensory and Motor Cortex
 INTRODUCTION
 Research has shown that imagining tactile sensations can activate the primary
 somatosensory cortex (S1) in a way that mirrors actual tactile experiences (Nierhaus et al., 2023).
 This is an example of sensory recruitment. Where mental imagery is the processing of a stimulus
 that does not directly correspond to the modality of the stimulus delivered. The exact activation
 of regions would depend on the content delivered. In this study, Nierhaus et al. investigated
 whether this activation also reflects specific patterns, meaning whether the activation in S1
 matches the specific tactile imagery imagined by participants. They used fMRI and multivariate
 pattern analysis to study the neural responses of healthy volunteers (n = 21) who either felt or
 imagined three different types of vibrotactile stimuli during the scans. Regardless of the specific
 content, imagining tactile sensations led to activation in the frontoparietal regions and the
 contralateral BA2 subregion of S1, consistent with previous findings. While univariate analysis
 did not reveal significant differences in activation across the different imagined stimuli,
 multivariate pattern classification was able to successfully decode the type of imagined stimulus
 from BA2 activity. Additionally, cross-classification analysis suggested that the neural patterns
 during imagined tactile sensations closely resemble those during actual perception of the stimuli.
 Those findings support the idea that mental tactile imagery engages content-specific neural
 activation patterns within sensory cortices, especially in S1.
 Here we created a reanalysis using data of 10 subjects from this study. Each participant
 had six runs of functional scans and six trials per condition. The ROI’s that were used in
 Nierhaus et al. (2023) are similar ones as the ones in this report. We included the somatosensory
 areas BA3b, BA1, BA2 and SII as well as frontal areas IFG and SMA.
