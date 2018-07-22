function result = MirrorImage(image)
%{
thanks to:
https://de.mathworks.com/matlabcentral/answers/324536-hi-i-m-trying-to-flip-an-image-without-any-built-in-commands-that-is-using-for-loops#answer_254387

[end:-1:1] def:
start from "end" dekrement to 1, in which end is bound to an array

so what i try is:

view from top:
+--------------+
|a)       <>   |
|   \/         |
|              |
+--- mirror ---+
|b)            |
|   /\         |
|         <>   |
+--------------+

foreach row in a) do
    - prepend row to b)
%}


result = image([end:-1:1],:,:);
end

