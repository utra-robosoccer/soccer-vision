function [img] = drawlines(mat,T,R,binary_image)
    P  = houghpeaks(mat,6,'threshold',ceil(0.5*max(mat(:))));
    hough_lines = houghlines(binary_image,T,R,P,'FillGap',5,'MinLength',10);    
    for k = 1:length(hough_lines)
        xy = [hough_lines(k).point1; hough_lines(k).point2];
        img = plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    end
end


%[2203,180]