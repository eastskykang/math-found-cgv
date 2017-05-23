%% Initialize everything

Iorig = imread('oz2.jpg'); % Load the image
[h,w,c] = size(Iorig);

rng(0);
M = rand(h,w)>0.9; % Create a mask
I0 = uint8(repmat(M,1,1,3).*double(Iorig)); % Apply the mask to the image

figure(1)
subplot(1,2,1)
imshow(Iorig)
title('Original image')
subplot(1,2,2)
imshow(I0);

%% PRIMAL DUAL ALGORITHM

% number of channels (rgb / grayscale)
if c ~= 3
    error('input should be rgb image')
end

% parameters (default)
if ~exist('max_iter', 'var')
    max_iter = 2000;
end
if ~exist('sigma', 'var') 
    sigma = 1.5;
end
if ~exist('tau', 'var') 
    tau = 1.5;
end
if  ~exist('lambda', 'var') 
    lambda = 5;
end
if ~exist('theta', 'var') 
    theta = 1;
end

% recovered image
Ix = zeros(h, w, c);

disp('-------------------------------------------------------------------')
disp('inpainting with following parameters')
disp(['max_iter = ', num2str(max_iter)])
disp(['sigma    = ', num2str(sigma)])
disp(['tau      = ', num2str(tau)])
disp(['lambda   = ', num2str(lambda)])
disp(['theta    = ', num2str(theta)])

disp('-------------------------------------------------------------------')
disp('primal dual algorithm...')

% initialization
I_double = double(I0);

% (x_0, y_0) in X x Y
x = reshape(I_double, [], 1, c);
y = grad(x, [h, w]);
y = y ./ max(y(:));

% x_bar_0 = x_0
x_bar = x;

% mask (vectorize)
m = repmat(M, 1, 1, 3);
m = m(:);

% iteration
for i=1:max_iter
    % TODO: termination condition
    
    if(~mod(i,50))
        fprintf(sprintf('(%5d / %5d)\n', i, max_iter));
    end
    
    % y_n+1
    grad_xn_bar = grad(x_bar, [h, w]);  % grad(x_bar_n) / size: (w*h) x 2 x c
    
    y = (y + sigma * grad_xn_bar) ...
        ./ max(1, sqrt(sum ((y + sigma * grad_xn_bar).^2, 2)));
    
    % x_n+1
    div_y = div(y, [h, w]);             % div(y_n+1) / size: (w*h) x 1 x c
    x_n = x;                % x before update (save temporary for x_bar)
    
    % case 1 (missing pixels)
    % for convenience, just update all first
    x = x - tau * (- div_y);
    
    % case 2 (otherwise)
    % update only not missing pixels
    x(m) = (x(m) + tau * lambda * I_double(m)) / (1 + tau * lambda);
    
    % x_bar_n+1
    x_bar = x + theta * (x - x_n);
    
    % show evolution
    if(i<5 || ~mod(i,50))
        
        % reshape
        Ix = reshape(x, h, w, c);
        
        figure(2)
        imshow(uint8(Ix));
        drawnow;
    end
end

% show the final result
disp('-------------------------------------------------------------------')
disp('show the result')

Ix = reshape(x, h, w, c);

figure(3)
subplot(1,2,1)
imshow(Iorig)
title('Original image')
subplot(1,2,2)
imshow(uint8(Ix))
title('TV-painted image')