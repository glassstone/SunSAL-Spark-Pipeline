function Courbes (x1, y1, x2, y2, labelx, labely, legend1, legend2)

plot(x1,y1,'b', x2, y2,'r');
legend(legend1, legend2);
xlabel (labelx);
ylabel (labely);
grid on;

end 