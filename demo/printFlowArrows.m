[sizey, sizex, ~] = size(Nx_out);  [Y,X] = meshgrid(1:sizex, 1:sizey);
X(flipud(Nx_out)==0 & flipud(Ny_out)==0)=NaN; Y(flipud(Nx_out)==0 & flipud(Ny_out)==0)=NaN;
f=1; figure, quiver(Y(1:f:end, 1:f:end),X(1:f:end, 1:f:end), flipud(Nx_out(1:f:end, 1:f:end)), -flipud(Ny_out(1:f:end, 1:f:end)), f), title('Normal flow'), axis([0 sizex/f 0 sizey/f]), axis off, axis image