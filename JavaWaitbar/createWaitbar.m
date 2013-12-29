function createWaitbar (figure, id)
global progressbarOK;
global jProgressBars;
try
    jProgressbar = jcontrol(figure, javax.swing.JProgressBar(), 'Visible', 'off'); 
    jProgressbar.setMaximum (1);
    jProgressbar.setMinimum (0);
    jProgressbar.setValue (1);
    jProgressbar.setBorderPainted (true);
    jProgressbar.setStringPainted (true);
    progressbarOK = 1;
    try
        jProgressBars (id) = jProgressbar; 
    catch e
        jProgressBars = containers.Map({id},{jProgressbar});
    end
catch e
    progressbarOK = 0;
end;