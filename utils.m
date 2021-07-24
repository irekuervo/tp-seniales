classdef utils
    methods (Static)
        %% Correlacion Cruzada
        function tau = tau_correlacion_cruzada(x,y,fs)
            [r,lags] = xcorr(x,y);
            [maximo,index] = max(r);
            tau = lags(index)/fs;
        end
        %% GCC PHAT
        function tau = tau_gcc_phat(x,y,fs)
            N=length(x);
            dftx = fft(x,N);
            dfty = fft(y,N);
            Gph = (dftx.*conj(dfty))./(abs(dftx).*abs(dfty));
            idftGph = ifft(Gph);
            [M I] = max(idftGph);
            if I > N/2
                tau = (I-N)/fs;
            else
                tau = I/fs;
            end
        end
        %% Ventaneo
        function [tau,tau_temporal] = tau_ventaneo(x,y,Nw,fs,window)
            N = length(x);
            n0 = Nw/2;
            cantidadDeVentaneos = 100;
            dn = round(N/cantidadDeVentaneos);
            resolucion = 10e6; %del histograma
            tau_temporal=[];
            w = [window(Nw); zeros(N-Nw,1)]; %empieza centrada en n0
            
            while n0 + Nw/2 < N
                xw = x.*w;
                yw = y.*w;
                tau_window =  utils.tau_gcc_phat(xw,yw,fs);
                tau_temporal = [tau_temporal, tau_window];
                w = circshift(w,dn);
                n0 = n0 + dn;
            end
            figure
            h = histogram(tau_temporal,resolucion);
            [maxcount, bin] = max(h.Values);
           tau = h.BinEdges(bin);
        end
        %% pendiente fuente
        % para esta disposicion de microfonos, la solucion puede ser el
        % signo opuesto al que se devuelve, dependera de si es viable por
        % las dimensiones del cuarto
        function [angulo, pendiente]= pendiente_fuente(t_retardo,distancia,velocidad)
            angulo = acos((velocidad*t_retardo)/distancia);
            pendiente = tan(angulo);
        end
        %% print
        % para mantener mismo estilo de plots
        function print(nombre)
            filename = strcat(nombre,'.png');
            %print(filename,'-dpng','-r300');
        end
        %% print
        % para mantener mismo estilo de plots
        function figure()
            figure('Position', [100 100 1600 600])
        end
        %% plot_mics
        % para mantener consistencia de colores e identificar bien a los
        % microfonos
        function  plot_mics(xn,micn,mic_color)
            plot(xn,micn,'Color',mic_color,'LineWidth',0.7);
        end
    end
end