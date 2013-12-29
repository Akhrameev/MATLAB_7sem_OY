function showCustomWaitbar (value, maximum, id)
global jProgressBars wait progressbarOK;
if (progressbarOK)
    jProgressbar = jProgressBars(id);
    jProgressbar.setVisible (true);
    jProgressbar.setMaximum (maximum);
    jProgressbar.setValue (value);
else
    try 
        close(wait)
    catch e
    end
    if maximum < 1
        maximum = 1;
    end
    wait = waitbar (value/maximum, 'In progress'); 
end