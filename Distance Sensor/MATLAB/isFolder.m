% Find Folder 
clc;clear;

% Establishing Current Folder Location
CurrentFolder = 'C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Distance Sensor\MATLAB';
DataOutput = 'Data Output';
FolderDestination = fullfile(CurrentFolder,DataOutput);

% New Folder Destination
% C:\Users\3cityDELL\OneDrive\Documents\MADWEC_3.0\Distance Sensor\MATLAB\Data Output

filename = 'mmm.txt';
a = magic(5)

% If the folder exist, Save file in it
if exist(FolderDestination, 'dir')

    writematrix(a, fullfile(FolderDestination,filename))
    fprintf(['Folder: "%s" was found in directory. \n '...
            'file "%s" was saved in folder: "%s" '],DataOutput,filename,DataOutput)

else % If the folder doesn't exist, create it.
    
    mkdir(FolderDestination);
    writematrix(a,FolderDestination)
    fprintf(['Folder: "%s" was not found in directory, so a new folder: "%s" was created! \n '...
            'File: "%s" was saved in folder: "%s" '],DataOutput,DataOutput,filename,DataOutput)

end