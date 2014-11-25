% Draw the triangle whose interior is empty
function tri = triangle_line(x,y,z)

xmin = floor(min(x));
xmax = ceil(max(x));
ymin = floor(min(y));
ymax = ceil(max(y));
tri = zeros(xmax,ymax);
line12 = drawline2(x(1:2),y(1:2),z(1:2));
line23 = drawline2(x(2:3),y(2:3),z(2:3));
line31 = drawline2([x(1) x(3)],[y(1) y(3)],[z(1) z(3)]);
for j = ymin:ymax
    for i = xmin:xmax
        if( i <= size(line12,1) && j <= size(line12,2) )
            if(line12(i,j) ~= 0)
                tri(i,j) = line12(i,j);
            end
        end
        if( i <= size(line23,1) && j <= size(line23,2) )
            if(line23(i,j) ~= 0)
                tri(i,j) = line23(i,j);
            end
        end
        if( i <= size(line31,1) && j <= size(line31,2) )
            if(line31(i,j) ~= 0)
                tri(i,j) = line31(i,j);
            end
        end
    end
end

% function result = drawline(a,b,c)
% 
% amn = floor(min(a));
% amx = ceil(max(a));
% bmn = floor(min(b));
% bmx = ceil(max(b));
% 
% delta = (b(2)-b(1))/(a(2)-a(1));
% delta_c = (c(2) - c(1))/( a(2)-a(1) );
% [mina,minI] = min(a);
% [maxa,maxI] = max(a);
% j = b(minI);
% k = c(minI);
% result = zeros(amx,bmx);
% 
% for i = amn:amx
%     if(round(j)<=0 || isnan(round(j)) == 1)
%         break;
%     end
%     result(i,round(j)) = k;
%     j = j + delta;
%     if(c(minI)<c(maxI))
%         k = k + delta_c;
%     else
%         k = k - delta_c;
%     end
% end
% end