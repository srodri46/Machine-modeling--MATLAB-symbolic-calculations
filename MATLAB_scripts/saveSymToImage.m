% MTM Project, Spring 2026
% Santiago Rodriguez-Mendoza
% Function: saveSymToImage

% Using 2 inputs will save the image as a PNG file
% If the 2nd input is a str, then filename==str
% Else the filename is the 1st input name.
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
%{
The saveSymToImage function automates the process of converting MATLAB symbolic 
expressions into high-resolution images by using LaTeX rendering. It begins by 
capturing the input variable's name and converting its mathematical content 
into a LaTeX-compatible string, which is then displayed in a figure window. 
The function features a dynamic naming logic: if a custom string is provided 
as a second argument, it uses that as the filename; otherwise, it defaults to 
the variable's workspace name. This utility is particularly effective for 
documenting complex coordinate transformation matrices or metrology error 
models directly from a script into a visual format suitable for repositories 
or technical presentations.
%}