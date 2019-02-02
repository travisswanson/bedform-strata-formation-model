function interpLine(x,y,col,lineW,lstyle)
%function to draw a line with a interpolated colormaping
    x = x(:)';
    y = y(:)';
    col = col(:)';
    z = zeros(size(x));
    surface([x;x],[y;y],[z;z],[col;col],'facecol','no','edgecol','interp','linew',lineW,'linestyle',lstyle);