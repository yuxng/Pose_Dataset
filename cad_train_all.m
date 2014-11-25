function cad = cad_train_all(cls, issave)

switch cls
    case 'aeroplane'
        N = 8;
    case 'bicycle'
        N = 6;
    case 'boat'
        N = 6;
    case 'bottle'
        N = 8;
    case 'bus'
        N = 6;
    case 'car'
        N = 10;
    case 'chair'
        N = 10;
    case 'diningtable'
        N = 6;
    case 'motorbike'
        N = 5;
    case 'sofa'
        N = 6;
    case 'train'
        N = 4;
    case 'tvmonitor'
        N = 4;
end

for i = 1:N
    disp(i);
    cad(i) = cad_train(cls, i);
end

if issave == 1
    switch cls
        case 'aeroplane'
            aeroplane = cad;
            save('CAD/aeroplane.mat', 'aeroplane');
        case 'bicycle'
            bicycle = cad;
            save('CAD/bicycle.mat', 'bicycle');
        case 'boat'
            boat = cad;
            save('CAD/boat.mat', 'boat');
        case 'bottle'
            bottle = cad;
            save('CAD/bottle.mat', 'bottle');            
        case 'bus'
            bus = cad;
            save('CAD/bus.mat', 'bus');            
        case 'car'
            car = cad;
            save('CAD/car.mat', 'car');
        case 'chair'
            chair = cad;
            save('CAD/chair.mat', 'chair');
        case 'diningtable'
            diningtable = cad;
            save('CAD/diningtable.mat', 'diningtable');            
        case 'motorbike'
            motorbike = cad;
            save('CAD/motorbike.mat', 'motorbike');
        case 'sofa'
            sofa = cad;
            save('CAD/sofa.mat', 'sofa');            
        case 'train'
            train = cad;
            save('CAD/train.mat', 'train');            
        case 'tvmonitor'
            tvmonitor = cad;
            save('CAD/tvmonitor.mat', 'tvmonitor');            
    end
end