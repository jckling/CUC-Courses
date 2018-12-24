%% »æÖÆÍ¼Ïñ
% N: Start value of x axis
% Name: Text display on legend
% YValue: Values on y axis
% Strength: Operation strength (different operation has different values)
function DrawTogether(Strength, YValue, Name, N)
x=N;
for i=1:length(Strength)
    y = YValue(:,i)';
    c = ones([1, length(y)]).*mod(x*5, 256);
    x = ones([1, length(y)]).*x;
    scatter(x, y, 25, c, 'filled', 'MarkerEdgeColor', 'b', 'DisplayName',[Name, ' (', num2str(Strength(i)), ')']);
	hold on;
    x = x+1;
end
end