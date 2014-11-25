function show_annotation_camera(cls)

path_image = sprintf('Images/%s_pascal', cls);
path_ann = sprintf('Annotations/%s', cls);

% load CAD models
CADPath = sprintf('CAD/%s.mat', cls);
object = load(CADPath);
cad = object.(cls);

figure;
files = dir(path_image);
N = numel(files);
i = 1;
while i <= N
    if files(i).isdir == 0
        filename = files(i).name;
        [pathstr, name, ext] = fileparts(filename);
        if isempty(imformats(ext(2:end))) == 0
            disp(filename);
            I = imread(fullfile(path_image, filename));

            % load annotation
            filename_ann = sprintf('%s/%s.mat', path_ann, name);

            if exist(filename_ann) == 0
                errordlg('No annotation available for the image');
            else
                object = load(filename_ann);
                record = object.record;
                tit = [];

                % show the bounding box
                for j = 1:numel(record.objects)
                    if strcmp(record.objects(j).class, cls) == 1
                        subplot(1,2,1);
                        imshow(I);
%                         hold on;                        
%                         bbox = record.objects(j).bbox;
%                         bbox_draw = [bbox(1) bbox(2) bbox(3)-bbox(1) bbox(4)-bbox(2)];
%                         rectangle('Position', bbox_draw, 'EdgeColor', 'g');
%                         % show anchor points
%                         if isfield(record.objects(j), 'anchors') == 1 && isempty(record.objects(j).anchors) == 0
%                             names = fieldnames(record.objects(j).anchors);
%                             for k = 1:numel(names)
%                                 if record.objects(j).anchors.(names{k}).status == 1
%                                     x = record.objects(j).anchors.(names{k}).location(1);
%                                     y = record.objects(j).anchors.(names{k}).location(2);
%                                     plot(x, y, 'ro');
%                                 end
%                             end
%                         end
%                         if record.objects(j).viewpoint.distance == 0
%                             str = sprintf('ac=%.2f, ec = %.2f, ', record.objects(j).viewpoint.azimuth_coarse, ...
%                                 record.objects(j).viewpoint.elevation_coarse);
%                         else
%                             str = sprintf('a=%.2f, e=%.2f, d=%.2f, ', record.objects(j).viewpoint.azimuth, ...
%                                 record.objects(j).viewpoint.elevation, record.objects(j).viewpoint.distance);
%                         end
%                         tit = strcat(tit, str);
%                         title(tit);
%                         hold off;
                        
                        % draw CAD model and camera
                        subplot(1,2,2);
                        cla;
                        hold on;
                        if record.objects(j).viewpoint.distance
                            [~, C] = projection(record.objects(j).viewpoint.azimuth, ...
                                record.objects(j).viewpoint.elevation, record.objects(j).viewpoint.distance/4);
                            theta = atan2(C(1), -C(2));
                            R = angle2dcm(theta, 0*pi/180, -90*pi/180);
                            R_c2w = inv(R);
                            T_c2w = C;
                            CameraVertex = zeros(5,3);
                            CameraVertex(1,:) = [0 0 0];
                            CameraVertex(2,:) = [-0.2  0.2  0.50];
                            CameraVertex(3,:) = [ 0.2  0.2  0.50];
                            CameraVertex(4,:) = [-0.2 -0.2  0.50];
                            CameraVertex(5,:) = [ 0.2 -0.2  0.50];
                            CameraVertex = ([R_c2w T_c2w]*[(CameraVertex');ones(1,5)])';
                            IndSetCamera = {[1 2 3 1] [1 4 2 1] [1 5 4 1] [1 5 3 1] [2 3 5 4 2]};
                            for iter_indset = 1:length(IndSetCamera)
                                patch('Faces', IndSetCamera{iter_indset}, 'Vertices', CameraVertex, 'FaceColor', 'b', 'FaceAlpha', 0.5);           
                            end
                        end
                        vertices = cad(record.objects(j).cad_index).vertices;
                        faces = cad(record.objects(j).cad_index).faces;
                        trimesh(faces, vertices(:,1), vertices(:,2), vertices(:,3), 'EdgeColor', 'k');
                        axis equal;
                        axis tight;
                        view(record.objects(j).viewpoint.azimuth-30, record.objects(j).viewpoint.elevation+15);
                        hold off;
                        pause;
                    end
                end             
            end
        end
    end
    i = i + 1;
end