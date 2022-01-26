function answer=func_inputparametrs()

% Display Input Dialog Box and Return the answer
prompt={'\bf Filtering Window Size (odd numbers only, >=3):',...
    '\bf Smoothing Window (odd numbers only, >=3 or else not applied):',...
    '\bf Grey Transformation Levels:',...
    '\bf Directional Filtered Outputs (Y/N, Yes/No):'};
name='Parameters Input:';
numlines=1;
defaultanswer={'9','9','25','No'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
        
end
