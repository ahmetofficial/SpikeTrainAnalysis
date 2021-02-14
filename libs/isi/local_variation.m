function lv = local_variation(isi)
    n  = length(isi);
    lv = (1 / (n-1)) * sum((3 * (isi(1:end-1) - isi(2:end)).^ 2) ./... 
                           ((isi(1:end-1) + isi(2:end)).^2));
end

