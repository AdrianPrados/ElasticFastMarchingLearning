function data = load_rail_data(task, demo_num)
data = cell(10, 1);
for i=1:10
    load(['RAIL/' task '/' num2str(i) '.mat'], 'dataset');
    data{i} = dataset(demo_num).pos;
end
data(3) = [];
end