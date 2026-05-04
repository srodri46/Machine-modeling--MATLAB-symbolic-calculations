% MTM Project, Spring 2026
% Santiago Rodriguez-Mendoza
% Variable Definition
clear; close all; clc
syms theta

% Rotation around Z-axis, large angles:
R_ZN = [cos(theta) -sin(theta) 0; 
     sin(theta) cos(theta)  0
     0          0           1];
% Small angle approximation: cos -> 1 y sin -> theta
R_ZN_approx = subs(R_ZN, [cos(theta), sin(theta)], [1, theta]);

% Display of results
disp('Large angle matrix:')
pretty(R_ZN) ;% latex(R)
disp('Small angle matrix:')
pretty(R_ZN_approx) ;% latex(R_approx)
%% H_ZR, where R->X
syms Zm Zo e_zz e_yz e_xz 
syms alpha_xz delta_xz delta_zz
errors= [e_zz,e_yz,e_xz,alpha_xz,delta_xz,delta_zz];
R_zx = [1 -e_zz e_yz;
       e_zz 1 -e_xz;
       -e_yz e_xz 1];

% Z, Translation vector
% Including error temrs: delta_xz, and delta_zz
% Squareness: alpha_xz
Z_vector = [delta_xz+alpha_xz*(Zm-Zo); 
            0; 
            (Zm-Zo)+delta_zz];
H_ZR = [R_zx, Z_vector; 
             0, 0, 0, 1];
pretty(H_ZR)
%% H_RF, where R->X
syms Xm Xo e_zx e_yx e_xx 
syms delta_xx delta_zx
errors= [errors,e_zx,e_yx,e_xx,delta_xx,delta_zx];
R_xF = [1 -e_zx e_yx;
       e_zx 1 -e_xx;
       -e_yx e_xx 1];

% Z, Translation vector
% Including error temrs: delta_xz and delta_zz

X_vector = [(Xm-Xo)+delta_xx; 
            0; 
            delta_zx];
H_RF = [R_xF, X_vector; 
             0, 0, 0, 1];
pretty(H_RF)
%% H_CF inverse
% no translation vector
C_vector = [0; 
            0; 
            0];
H_CF = [R_ZN_approx, C_vector; 
             0, 0, 0, 1];
pretty(H_CF)
%% HTM Model - Complete
syms T_x T_y T_z
% 3D Vector
T = [T_x; T_y; T_z];
% Homogeneous vector conversion
T_h = [T; 1];
% HTM multiplication
P = H_CF * H_RF * H_ZR * T_h;
pretty(P);% latex(P_linear)
%% Symplification, first order angular errors
% We only consider linear terms
P_linear = taylor(P, errors, 'Order', 2);
pretty(P_linear); %latex(P_linear)
%% Numerical evaluation
% Extraction of first 3 components (x, y, z)
P_coords = P(1:3);
vars_in_model = symvar(P_coords);
num_values = zeros(size(vars_in_model));
for i = 1:length(vars_in_model)
    name = char(vars_in_model(i));
    % Check if the name starts with 'e_', 'alpha' or 'theta'
    if startsWith(name, {'e_', 'alpha', 'delta'})
        num_values(i) = randn() * 1e-6;
    elseif startsWith(name, {'theta', 'X', 'Z', 'T'})
        if contains(name, 'theta')
            num_values(i) = deg2rad(45); % 45 degrees in radians
        else
            num_values(i) = 10 + rand() * 40; % 10 to 50 mm
        end
    else
        num_values(i) = 0; % For security reasons, anything unknown is 0
    end
end
% Evaluate both models with the same set of values.
P_num = double(subs(P(1:3), vars_in_model, num_values));
P_linear_num = double(subs(P_linear(1:3), vars_in_model, num_values));
% Calculate the difference (Linearization error)
diff_vector = P_num - P_linear_num;
% Report of the results
T = table(P_num, P_linear_num, diff_vector, ...
    'VariableNames', {'General', 'Lineal', 'Difference'}, ...
    'RowNames', {'X', 'Y', 'Z'});

disp('--- General and linear model comparison (Same numerical values) ---');
disp(T);
% Validation
max_error = max(abs(diff_vector));
if max_error < 1e-8
    fprintf('Successful validation: The linearization error is (%e).\n', max_error);
else
    fprintf('Warning: The error is %e.\n', max_error);
end
%% Exporting symbolic variables as images
% Using the saveSymToImage function
% Using 2 inputs will save the image as a PNG file
% If the 2nd input is a str, then filename==str
% Else the filename is the 1st input name.

% saveSymToImage(P_linear)

function saveSymToImage(symVar, save_name)
    % SAVESYMTOIMAGE Converts a symbolic variable to PNG image using LaTeX.
    % String conversion
    Var_name=inputname(1);
    str = ['$', latex(symVar), '$'];
    % Figure creation
    f = figure('Visible', 'on');
    axes('Visible', 'off');
    % Drawing the equation in the center
    t = text(0.5, 0.5, str, 'Interpreter', 'latex', 'FontSize', 30);
    set(t, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    if nargin > 1 % File exporting loop
        if isstring(save_name) || ischar(save_name)
            fileName = [save_name, '.png'];
        else
            fileName = [Var_name, '.png'];
        end
        exportgraphics(f, fileName, 'Resolution', 300);
        fprintf('Image save as: %s\n', fileName);
    end
    %pause(2); close(f); % Display and close figure after 2 seconds
end