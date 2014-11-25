% reduce certain rows in the matrix
function newx2d = remove(x2d,reduction)
b = ones(size(x2d,1),1);
b(reduction) = 0;
val = find(b);
newx2d = x2d(val,:);
