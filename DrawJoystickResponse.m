figure(1);
clf;
polaraxes;
hold on;
for trial = 1 : numel(joystickResponse)
    isResponseMarked = joystickResponse{trial}(:,1)~=0;
    polarplot(joystickResponse{trial}(isResponseMarked, 2), joystickResponse{trial}(isResponseMarked,3));
    rlim([0,1.5]);
end
legend;