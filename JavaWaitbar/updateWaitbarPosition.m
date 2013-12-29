function updateWaitbarPosition (position, id)
global jProgressBars progressbarOK;
if (progressbarOK)
    try
        jProgressbar = jProgressBars(id);
        jProgressbar.setPosition (position);
    catch e
            
    end    
end