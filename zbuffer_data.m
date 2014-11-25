% This file makes a '.mat' file that contains information of azimuth, 
% elevation, distance, depth and visible points
% data.name : name of the '.mat' file
% data.azi : corresponding azimuth
% data.ele : corresponding elevation
% data.dist : corresponding distance
% data.vis : vector that contains 0 or 1 which represent corresponding anchor
% point is visible or not
% data.p : matrix that contains position of visible anchor points
% interval_check : difference between depth of every anchor points and
% that of plane generated by z-buffer
function data = zbuffer_data(cls, index, azi_part, ele_part, dist)

switch cls
    case 'car'
        anchor = {'left_front_wheel', 'left_back_wheel',...
            'right_front_wheel', 'right_back_wheel',...
            'upper_left_windshield', 'lower_left_windshield',...
            'upper_right_windshield', 'lower_right_windshield',...
            'upper_left_rearwindow', 'lower_left_rearwindow',...
            'upper_right_rearwindow', 'lower_right_rearwindow',...
            'left_front_light', 'right_front_light',...
            'left_back_trunk', 'right_back_trunk',...
            'left_window_center', 'right_window_center',...
            'left_window_up', 'right_window_up'};
    case 'chair'
        anchor = {'back_upper_left', 'back_upper_right',...
            'seat_upper_left', 'seat_upper_right',...
            'seat_lower_left', 'seat_lower_right',...
            'leg_upper_left', 'leg_upper_right',...
            'leg_lower_left', 'leg_lower_right'};
end
filename = sprintf('Anchor/%s/%02d.off', cls, index);
vertices = load_off_file(filename);

k = 0;
for i = 1:azi_part + 1
    for j = 1:ele_part + 1
        k = k + 1;
        [vis,p] = zbuffer_anchor(vertices, anchor, cls, index, (i-1)*(360/azi_part), (j-1)*(90/ele_part), dist);
        data(k).name = sprintf('%02d_plane_%d_%d_%d',index,(i-1)*(360/azi_part),(j-1)*(90/ele_part),dist);
        data(k).azi = (i-1)*(360/azi_part);
        data(k).ele = (j-1)*(90/ele_part);
        data(k).dist = dist;
        data(k).p = p;
        data(k).vis = vis;
        if(vis(1)&&vis(2)&&vis(17)||vis(1)&&vis(2)&&vis(19)||vis(1)&&vis(17)&&vis(19)||vis(2)&&vis(17)&&vis(19))
            if(vis(1)*vis(2)*vis(17)*vis(19)==0)
                data(k).err = sprintf('%02d_plane_mesh_%d_%d_%d',index,(i-1)*(360/azi_part),(j-1)*(90/ele_part),11);
            end
        elseif(vis(3)&&vis(4)&&vis(18)||vis(3)&&vis(4)&&vis(20)||vis(3)&&vis(18)&&vis(20)||vis(4)&&vis(18)&&vis(20))
            if(vis(3)*vis(4)*vis(18)*vis(20)==0)
                data(k).err = sprintf('%02d_plane_mesh_%d_%d_%d',index,(i-1)*(360/azi_part),(j-1)*(90/ele_part),11);
            end
        end
    end
end