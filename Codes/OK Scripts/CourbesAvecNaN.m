function CourbesAvecNaN (x1, y1, x2, y2, labelx, labely, legend1, legend2)

idxs1 = ~isnan(y1);
plot(x1(idxs1), y1(idxs1));
hold on;
idxs2 = ~isnan(y2);
plot(x1(idxs2), y2(idxs2));
hold off;
%plot(x1,y1,'b', x2, y2,'r');
legend(legend1, legend2);
xlabel (labelx);
ylabel (labely);
grid on;

end 