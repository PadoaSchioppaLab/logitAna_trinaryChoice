We provide one example session of trinary choices and a Matlab script that performs a logistic analysis, as described in Padoa-Schioppa, Neuron, 2022. 
The file exampleSession_data.mat includes the variables goodTrials and sessionParams. In goodTrials (600x13), each row is one trial, and columns are as follows:
- Col 1: trial number (only successful trials included)
- Cols 2-4: qA, qB, qC
- Cols 5-7: pA, pB, pC
- Cols 8-10: position on monitor of offer A, B, C – not relevant to the analysis
- Col 11: chosen juice (1=A, 2=B, 3=C)
- Col 12: chosen position (1=A, 2=B, 3=C) – not relevant to the analysis
- Col 13: juice delivered (0=no, 1=yes)
Variable sessionParams is a structure describing the parameters used in the session. In practice, the analysis only uses the quantity range (to construct the figures). For additional information, contact the author at camillo@wustl.edu

