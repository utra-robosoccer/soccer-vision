function drawfield(lines, points)
    [h, ~] = size(lines);

    for i = 1:h
        plot(lines(i,[1,3]), lines(i,[2,4]));
        hold on;
    end

    [h, ~] = size(points);

    for i = 1:h
        plot(points(i,1), points(i,2), 'o');
        hold on;
    end
    
    grid on;
    hold off;
end