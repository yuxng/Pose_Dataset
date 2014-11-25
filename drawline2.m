function line = drawline2(x, y, z)

steep = abs(y(2) - y(1)) > abs(x(2) - x(1));
if(steep)
    temp = x;
    x = y;
	y = temp;
end
xmax = ceil(max(x));
xmin = floor(min(x));
ymax = ceil(max(y));
ymin = floor(min(y));
line = zeros(xmax,ymax);
steepz = abs(z(2) - z(1))/abs(x(2) - x(1));
deltax = abs(x(2) - x(1));
deltay = abs(y(2) - y(1));
error = deltax / 2;
if(x(1)<x(2))
    ix = floor(x(1));
else
    ix = ceil(x(1));
end
if(y(1)<y(2))
    iy = floor(y(1));
else
    iy = ceil(y(1));
end
iz = z(1);
if(x(1) < x(2)) 
    inc = 1;
else
    inc = -1;
end
if(y(1) < y(2))
    ystep = 1; 
else
    ystep = -1;
end
for i = xmin:xmax
    if(ix>0 && iy>0)
    if(steep)
        line(iy,ix) = iz;
    else
        line(ix,iy) = iz;
    end
    end
    error = error - deltay;
    if(error < 0)
        iy = iy + ystep;
        error = error + deltax;
    end
    ix = ix + inc;
    if(z(1)<z(2))
        iz = iz + steepz;
    elseif(z(1)>z(2))
        iz = iz - steepz;
    end
end
end

