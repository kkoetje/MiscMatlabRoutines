

function [beam] = TransformNORTEK_ENUtobeam(Vector_UNH,samplingFreq)
%% convert from ENU to beam
%Vector Head for Vertical mounted compas (UNH Vector):
T = [2.7529 -1.4004 -1.3623;...
    -0.0232 2.3083 -2.2891;...
    0.3569 0.3418 0.3325];

%Vector Head for Horizontal mounted compas (NRL Vector):
% T = [-0.3459 -0.3396 -0.3477;...
%      0.0193 2.2820 -2.2979;...
%      2.6555 -1.3125 -1.3440];

%T = T/4096;   % Scale the transformation matrix correctly to floating
%point numbers, but our transformation matrix is already scaled. 

T_org = T;

           

% heading, pitch and roll are the angles output in the data in degrees
heading = Vector_UNH.Heading;
pitch = Vector_UNH.Pitch;
roll = Vector_UNH.Roll;

hh = pi*(heading-90)/180;
pp = pi*pitch/180;
rr = pi*roll/180;

% Convert to beam coordinates
velStart(1) = 1;
velEnd(1) = samplingFreq;
idd = 1:samplingFreq;
velCNT = 0;

if rem(length(Vector_UNH.Velocity_East),samplingFreq)==0
    lenhh = length(hh); 
else
    dum = length(Vector_UNH.Velocity_East)-rem(length(Vector_UNH.Velocity_East),samplingFreq); %if instrument stopped in the middle of run
    lenhh = dum/samplingFreq;
end

for cnt = 2:lenhh
velStart(cnt) = velEnd(end)+1;
velEnd(cnt) = velEnd(end)+samplingFreq;
end

beam1 = zeros(samplingFreq,length(velEnd));
beam2 = zeros(samplingFreq,length(velEnd));
beam3 = zeros(samplingFreq,length(velEnd));
for cnt = 1:lenhh%parfor cnt = 1:lenhh
% Make heading matrix
H = [cos(hh(cnt)) sin(hh(cnt)) 0; -sin(hh(cnt)) cos(hh(cnt)) 0; 0 0 1];

% Make tilt matrix
P = [cos(pp(cnt)) -sin(pp(cnt))*sin(rr(cnt)) -cos(rr(cnt))*sin(pp(cnt));...
      0             cos(rr(cnt))          -sin(rr(cnt));  ...
      sin(pp(cnt)) sin(rr(cnt))*cos(pp(cnt))  cos(pp(cnt))*cos(rr(cnt))];

% Make resulting transformation matrix
R = H*P*T;

enu = [Vector_UNH.Velocity_East(velStart(cnt):velEnd(cnt),1), Vector_UNH.Velocity_North(velStart(cnt):velEnd(cnt),1), Vector_UNH.Velocity_Up(velStart(cnt):velEnd(cnt),1)]';

%for kk = 1:64;
%    velCNT = velCNT+1;
    
    %beam(velCNT,:) = inv(R)*enu(:,kk);
    beam_sub = mtimes(inv(R),enu)';
    beam1(:,cnt) = beam_sub(:,1);
    beam2(:,cnt) = beam_sub(:,2);
    beam3(:,cnt) = beam_sub(:,3);
    
    %xyz(velCNT,:) = T_org*inv(R)*enu(:,kk);
%end


end

b1 = reshape(beam1,size(beam1,1)*size(beam1,2),1);
b2 = reshape(beam2,size(beam2,1)*size(beam2,2),1);
b3 = reshape(beam3,size(beam3,1)*size(beam3,2),1);

beam = [b1,b2,b3];
  
%% Origional Nortek Transform File

% % % Transform.m is a Matlab script that shows how velocity data can be 
% % % transformed between beam coordinates and ENU coordinates. Beam 
% % % coordinates are defined as the velocity measured along the three 
% % % beams of the instrument.
% % % ENU coordinates are defined in an earth coordinate system, where
% % % E represents the East-West component, N represents the North-South
% % % component and U represents the Up-Down component.
% % 
% % % Note that the transformation matrix must be recalculated every time
% % % the orientation, heading, pitch or roll changes.
% % 
% % % Transformation matrix for beam to xyz coordinates,
% % % the values can be found from the header file that is generated in the
% % % conversion of data to ASCII format
% % % This example shows the transformation matrix for a standard Aquadopp head
% % T =[ 2896  2896    0 ;...
% %     -2896  2896    0 ;...
% %     -2896 -2896 5792  ];
% % 
% % T = T/4096;   % Scale the transformation matrix correctly to floating point numbers
% % 
% % T_org = T;
% % 
% % % If instrument is pointing down (bit 0 in status equal to 1)
% % % rows 2 and 3 must change sign
% % % NOTE: For the Vector the instrument is defined to be in 
% % %       the UP orientation when the communication cable 
% % %       end of the canister is on the top of the canister, ie when 
% % %       the probe is pointing down.
% % %       For the other instruments that are used vertically, the UP 
% % %       orientation is defined to be when the head is on the upper
% % %       side of the canister.
% % 
% % 
% % if statusbit0 == 1,
% %    T(2,:) = -T(2,:);   
% %    T(3,:) = -T(3,:);   
% % end
% % 
% % % heading, pitch and roll are the angles output in the data in degrees
% % 
% % hh = pi*(heading-90)/180;
% % pp = pi*pitch/180;
% % rr = pi*roll/180;
% % 
% % % Make heading matrix
% % H = [cos(hh) sin(hh) 0; -sin(hh) cos(hh) 0; 0 0 1]
% % 
% % % Make tilt matrix
% % P = [cos(pp) -sin(pp)*sin(rr) -cos(rr)*sin(pp);...
% %       0             cos(rr)          -sin(rr);  ...
% %       sin(pp) sin(rr)*cos(pp)  cos(pp)*cos(rr)]
% % 
% % % Make resulting transformation matrix
% % R = H*P*T;
% % 
% % 
% % % beam is beam coordinates, for example beam = [0.23 ; -0.52 ; 0.12]
% % % enu is ENU coordinates
% % 
% % % Given beam velocities, ENU coordinates are calculated as
% % enu = R*beam
% % 
% % % Given ENU velocities, beam coordinates are calculated as
% % beam = inv(R)*enu
% % 
% % 
% % % Transformation between beam and xyz coordinates are done using
% % % the original T matrix 
% % xyz = T_org*beam
% % beam = inv(T_org)*xyz
% % 
% % % Given ENU velocities, xyz coordinates are calculated as
% % xyz = T_org*inv(R)*enu
