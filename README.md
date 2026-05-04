# Machine-modeling--MATLAB-symbolic-calculations
Machine Tool Metrology based project, the study of a CFRZ frame is made as well as the proposal of a MATLAB method to perform symbolic and numerical calculations.

This repository includes a MATLAB_scripts folder where the main script (SymbolicCalculations) is located as well as suplementary funcions, the main script generates the vector, and homogeneous transformation matrices for the CFRZ stage (HTM). Once the HTM model elements are ready, the symbolic operation is made where the output is a 4x1 vector that represents the part-sample vector in therms of the tool-detector (T) vector.

The code can also perform numerical calculations, by assigning numerical values to the variables and errores used in the symbolical modeling, also, a comparative with the general solution and first order error approximation is made. Finally, the function (saveSymToImage) can export in a figure format (png, jpg, pdf) the desired matrix or vector.

The CFRZ Stage folder contain the drawings made on AUTOCAD for the machine modeling, which is the base for the analytic-symbolic implementation in MATLAB.
