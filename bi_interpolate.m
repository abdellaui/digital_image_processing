function result = bi_interpolate(sI, tempCoard)


        xUp = ceil(tempCoard(1))
        xDown = floor(tempCoard(1))
        
        yUp = ceil(tempCoard(2))
        yDown = floor(tempCoard(2))
        
        x_0 = tempCoard(1) - xDown
        y_0 = tempCoard(2) - yDown
        
        w_0 = (1-y_0)*(1-x_0)
        w_1 = (1-y_0)*x_0
        w_2 = y_0*(1-x_0)
        w_3 = y_0*x_0
        result = w_0*sI(yDown, xDown) + w_1*sI(yDown, xUp) + w_2*sI(yUp, xDown) + w_3*sI(yUp, xUp);

end

