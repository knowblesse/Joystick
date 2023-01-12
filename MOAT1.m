%20 top, 1~20 clockwise
% 1~20:stimuli (clockwise(1to20), 20 is top)
% 21~24:target locations
% 25~28:correct response
% 29:1st response
% 30:1st RT
% 31:2nd response
% 32:2nd RT
% 33:3rd response
% 34:3rd RT
% 35:4th response
% 36:4th RT
% 37:congruency (search:eye, RR 1, LL 2, RL, 3 LR, 4)
% 40:subject#


clc;
clear;
close all;
rng('shuffle')
Screen('Preference', 'SkipSyncTests', 1);

%% Joystick Setup
joy = vrjoystick(1);


%% Exp

subj = input('subject number: ');

bgcolor=[0 0 0];
white=[255 255 255];
[w,ScreenRect] = Screen(0, 'OpenWindow', bgcolor);
HideCursor;

a = clock; 
if a(2)<=9; Month=strcat('0',num2str(a(2))) ; else Month=num2str(a(2));  end;
if a(3)<=9; Day=strcat('0',num2str(a(3))) ; else Day=num2str(a(3));  end;
if rem(a(4),12)<=9; Hour=strcat('0',num2str(rem(a(4),12))) ; else Hour=num2str(rem(a(4),12)); end;
if a(5)<=9; Min=strcat('0',num2str(a(5))) ; else Min=num2str(a(5));  end;
if a(4)<=11; AmPm='am'; else AmPm= 'pm'; end;
whattime= strcat(Month,'_',Day,'_',Hour,'_',Min, AmPm);

% key set
Zkey=KbName('z');
Xkey=KbName('x');
spacebar=KbName('space');

x=ScreenRect(3)/2;
y=ScreenRect(4)/2;
center=[x,y];

ts=30; %digit size
tc=[200 200 0]; %digit color

radius=300; %display-center to digits
circleradius=20; %topcircle radius (holder)
circlelocationcorrection=9;
DrawArcRadius=330;
numberofstimuli=20; % # of digits
numberoftarget=3; %number of target except for the very top (the top is always target digit), so total number of targets is "numberoftarget"+1(the top)
totalnumberoftarget=numberoftarget+1;
ns=[1:numberofstimuli];
degreeb2wstimuli=360/numberofstimuli;

%20 top, 1~20 clockwise
predegreeofstimuli=degreeb2wstimuli*ns;
degreeofstimuli(6:20)=predegreeofstimuli(1:15);
degreeofstimuli(1:5)=predegreeofstimuli(16:20);


for i=1:numberofstimuli
locationofstimuli{i}=[cosd(degreeofstimuli(i))*radius,sind(degreeofstimuli(i))*radius]+[x,y];
end

%%
for i=1:60 %make 60 trials
targetlocation=[randperm(numberofstimuli-1,numberoftarget), numberofstimuli]; %numberofstimuli is the top location
ordersortedtargetlocation=sort(targetlocation); % 타겟 위치 오름정렬  % response는 4,1,2,3, 순서임 (4번째(마지막 것)이 20위치라서 첫 response)

for ii=1:numberofstimuli
predigits(ii)=randi(7)+2;
end

for iii=1:totalnumberoftarget
pretarget(iii)=randi(2);
end

digits=predigits;
digits(ordersortedtargetlocation)=pretarget;

%correct responses with correct response order
correcttarget(2:4)=pretarget(1:3);
correcttarget(1)=pretarget(4);

list(i,1:20)=digits;
list(i,21:24)=ordersortedtargetlocation;
list(i,25:28)=correcttarget;
end


%%
for i=121:180 % reverse of the first 60 trials in 121~180, and then trial order randomized
list(i,1:19)=flip(list(i-120,1:19));
list(i,20)=list(i-120,20);
list(i,21:24)=20-list(i-120,21:24);
list(i,24)=20;
list(i,25:28)=list(i-120,25:28);
end

%ranmdizing is below section

%% make remaining trials
list(randperm(60)+60,:)=list(1:60,:); %60~120 is random of 1~60
list(randperm(60)+180,:)=list(121:180,:); %181~240 is random of 121~180

list(randperm(60)+120,:)=list(181:240,:); %121~180 is random of 181~240 due to 1~60 and 121~180 are the reversed order which is the pattern
%% Practice Trials (241~280)
list(241:250,:)=list(11:20,:); %241~250 = 1~60 block
list(251:260,:)=list(71:80,:); %251~260 = 61~120 block
list(261:270,:)=list(131:140,:); %261~270 = 121~180 block
list(271:280,:)=list(191:200,:); %271~280 = 181~240 block
%%
list(1:350, 29:40)=0;

%% block order counterbalancing
% if mod(subj,2)==1 % subj odd
%     trialorder=[241:280 1:240];
% elseif mod(subj,2)==0 %subj even
%     trialorder=[251:260 241:250 271:280 261:270 61:120 1:60 181:240 121:180];
% end

trialorder=[1 2];
joystickResponse = cell(numel(trialorder),1);

%%% experiment
for trial=trialorder


    %% instruction

    % if trial==1
    %     Screen('TextSize', w , 60);
    %     DrawFormattedText(w, 'Search. Clockwise','center',y-100, white);
    %     DrawFormattedText(w, 'Move. Clockwise','center',y+100, white);
    %     Screen('Flip', w);
    %     WaitSecs(1);
    %     KbWait;
    % end

%     if trial==1
%         myimgfile='RR.jpg';
%         ima=imread(myimgfile, 'jpg');
%         Screen('PutImage', w, ima); % put image on screen
%         Screen('Flip',w); % now visible on screen
%         WaitSecs(1);
%         KbWait;
%     end
% 
% 
%     if trial==241
%         myimgfile='RR.jpg';
%         ima=imread(myimgfile, 'jpg');
%         Screen('PutImage', w, ima); % put image on screen
%         Screen('Flip',w); % now visible on screen
%         WaitSecs(1);
%         KbWait;
%     end
% 
%     if trial==61
%         myimgfile='RL.jpg';
%         ima=imread(myimgfile, 'jpg');
%         Screen('PutImage', w, ima); % put image on screen
%         Screen('Flip',w); % now visible on screen
%         WaitSecs(1);
%         KbWait;
%     end
% 
%     if trial==251
%         myimgfile='RL.jpg';
%         ima=imread(myimgfile, 'jpg');
%         Screen('PutImage', w, ima); % put image on screen
%         Screen('Flip',w); % now visible on screen
%         WaitSecs(1);
%         KbWait;
%     end
% 
%     if trial==121
%         myimgfile='LL.jpg';
%         ima=imread(myimgfile, 'jpg');
%         Screen('PutImage', w, ima); % put image on screen
%         Screen('Flip',w); % now visible on screen
%         WaitSecs(1);
%         KbWait;
%     end
% 
%     if trial==261
%         myimgfile='LL.jpg';
%         ima=imread(myimgfile, 'jpg');
%         Screen('PutImage', w, ima); % put image on screen
%         Screen('Flip',w); % now visible on screen
%         WaitSecs(1);
%         KbWait;
%     end
% 
%     if trial==181
%         myimgfile='LR.jpg';
%         ima=imread(myimgfile, 'jpg');
%         Screen('PutImage', w, ima); % put image on screen
%         Screen('Flip',w); % now visible on screen
%         WaitSecs(1);
%         KbWait;
%     end
% 
%     if trial==271
%         myimgfile='LR.jpg';
%         ima=imread(myimgfile, 'jpg');
%         Screen('PutImage', w, ima); % put image on screen
%         Screen('Flip',w); % now visible on screen
%         WaitSecs(1);
%         KbWait;
%     end
    %% Blank Display
    Screen('Flip', w);
    WaitSecs(.5);
    %% Top Holder
    Screen('frameoval',w,[255 255 255], [x-circleradius+circlelocationcorrection,y-radius-circleradius-circlelocationcorrection,x+circleradius+circlelocationcorrection,y-radius+circleradius-circlelocationcorrection],1);
    Screen('Flip', w);
    WaitSecs(.3);
    %% Search
    Screen('TextSize', w , ts );
    Screen('frameoval',w,[255 255 255], [x-circleradius+circlelocationcorrection,y-radius-circleradius-circlelocationcorrection,x+circleradius+circlelocationcorrection,y-radius+circleradius-circlelocationcorrection],1);
    for i=1:numberofstimuli
        DrawFormattedText(w, num2str(list(trial,i)),locationofstimuli{i}(1),locationofstimuli{i}(2),tc);
    end

    % Screen('DrawArc',w,white,[x-DrawArcRadius,y-DrawArcRadius,x+DrawArcRadius,y+DrawArcRadius],0,5)

    Screen('Flip', w);
    % WaitSecs(1);
    % KbWait;


    %% Response

    tic;% begin tic-toc-toc-toc-toc
    lastResponseSaveTime = 0;
    joystickResponseSaveInterval = 0.05; % save joystick info every this seconds.
    maxJoystickResponseSaveTime = 20;
    joystickResponse{trial} = zeros(maxJoystickResponseSaveTime / joystickResponseSaveInterval, 3); % timestamp, response
    joystickResponseIndex = 1;

    while list(trial,29)*list(trial,31)*list(trial,33)* list(trial,35)==0 %until four responses
        
        if cputime > lastResponseSaveTime + joystickResponseSaveInterval
            x = axis(joy, 1);
            y = -axis(joy, 2);
            [theta, rho] = cart2pol(x,y);
            lastResponseSaveTime = cputime;
            joystickResponse{trial}(joystickResponseIndex, 1) = lastResponseSaveTime;
            joystickResponse{trial}(joystickResponseIndex, 2) = theta;
            joystickResponse{trial}(joystickResponseIndex, 3) = rho;
            joystickResponseIndex = joystickResponseIndex + 1;
        end

        [keyIsDown, secs, keyCode]=KbCheck;
        if keyIsDown  %1st response identity (1~4)
            if  list(trial,29)==0
                list(trial,30)=toc; %1st response RT
                if keyCode(Zkey)
                    list(trial,29)=1;
                elseif keyCode(Xkey)
                    list(trial,29)=2;
                end
            elseif list(trial,29)>0 && list(trial,31)==0
                list(trial,32)=toc; %2nd response RT and Identity
                if keyCode(Zkey)
                    list(trial,31)=1;
                elseif keyCode(Xkey)
                    list(trial,31)=2;
                end
            elseif list(trial,31)>0 && list(trial,33)==0
                list(trial,34)=toc; %3rd response RT and Identity
                if keyCode(Zkey)
                    list(trial,33)=1;
                elseif keyCode(Xkey)
                    list(trial,33)=2;
                end
            elseif list(trial,33)>0 && list(trial,35)==0
                list(trial,36)=toc; %4th response RT and Identity
                if keyCode(Zkey)
                    list(trial,35)=1;
                elseif keyCode(Xkey)
                    list(trial,35)=2;
                end
            end
            KbReleaseWait
        end
    end

end

%% save data
filename=strcat(whattime);
save([filename,'.mat'], 'list');

%% end message
Screen('TextSize', w , 65);
DrawFormattedText(w, 'END! Thank you!','center','center', white);
Screen('Flip', w);
WaitSecs(1);
KbWait;

Screen('closeall');