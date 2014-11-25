% Draw the triangle whose interior is full
function tri = triangle(x,y,z)
xmin = floor(min(x));
xmax = ceil(max(x));
ymin = floor(min(y));
ymax = ceil(max(y));
tri = zeros(xmax,ymax);
for j = ymin:ymax
    for i = xmin:xmax
        alpha = f23(i,j,x,y)/f23(x(1),y(1),x,y);
        beta = f31(i,j,x,y)/f31(x(2),y(2),x,y);
        gamma = f12(i,j,x,y)/f12(x(3),y(3),x,y);
        if(alpha > 0 && beta > 0 && gamma > 0 )
            tri(i,j) = alpha*z(1)+beta*z(2)+gamma*z(3);
        end
    end
end
end

function val = f23(i,j,x,y)
val = (y(2)-y(3))*i + (x(3)-x(2))*j + x(2)*y(3) - x(3)*y(2);
end

function val = f31(i,j,x,y)
val = (y(3)-y(1))*i + (x(1)-x(3))*j + x(3)*y(1) - x(1)*y(3);
end

function val = f12(i,j,x,y)
val = (y(1)-y(2))*i + (x(2)-x(1))*j + x(1)*y(2) - x(2)*y(1);
end



        