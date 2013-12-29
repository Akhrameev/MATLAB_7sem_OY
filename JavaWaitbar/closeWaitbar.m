function closeWaitbar (id)
global wait progressbarOK jProgressBars;
if (progressbarOK)
    jProgressbar = jProgressBars(id);
    jProgressbar.setVisible (false);
else
    close (wait);
end;