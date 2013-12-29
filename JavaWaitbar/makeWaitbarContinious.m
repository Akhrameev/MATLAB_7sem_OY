function makeWaitbarContinious (id)
global jProgressBars progressbarOK;
if (progressbarOK)
    try
        jProgressbar = jProgressBars(id);
        jProgressbar.setIndeterminate (true);
    catch e
            
    end   
end
