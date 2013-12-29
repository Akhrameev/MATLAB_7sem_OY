function showWaitbar (id)
global wait progressbarOK jProgressBars;
global solvingIterationCount solvingIterationCurrent;
if (progressbarOK)
    jProgressbar = jProgressBars(id);
    jProgressbar.setVisible (true);
    jProgressbar.setMaximum (solvingIterationCount);
    jProgressbar.setValue (solvingIterationCurrent);
else
    try 
        close(wait)
    catch e
    end
	if solvingIterationCount < 1
		solvingIterationCount = 1;
	end
    wait = waitbar (solvingIterationCurrent/solvingIterationCount, 'In progress'); 
end