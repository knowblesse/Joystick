%% Assign JoyStick
joy = vrjoystick(1);

%% Setup figure
fig = figure('Name', 'Joystick Control');
ax = polaraxes;

%%
fig = figure('Name', 'test');
ax = axes;

traj = zeros(50, 2);

while true
    x = axis(joy, 1);
    y = -axis(joy, 2);
    [theta, rho] = cart2pol(x,y);

    traj = [traj(2:end, :); [theta, rho]];
    polarplot(traj(:,1), traj(:,2));
    rlim([0,2]);
    drawnow;
    pause(0.05);
end
