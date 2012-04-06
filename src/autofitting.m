% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Celli Alessio, Rafanelli Davide
%
% This script assumes these variables are defined:
%
%   dati - input data.
%   target - target data.

% Massimo errore della colonna con le maggiori istanze 
%dell'error histogram
MAX_ERR = 0.01; 

% Minimo valore di regressione del nostro sistema
MIN_REG = 0.91;

% Numero di ripetizioni del training utilizzando la stessa rete,
% variando quindi soltanto i pesi dei neuroni 
MAX_RIP = 10;
 
% Numero di neuroni nascosti di partenza
INIT_HIDDEN_LAYER = 10; 

% Massimo numero di neuroni nascosti
MAX_HID_LAYER = 20; 

load ../data/inputWork.csv;
load ../data/targetWork.csv;

inputs = inputWork';
targets = targetWork';


% Inizializzazione del miglior valore di errore individuato dal sistema
b_err = inf;  

% Inizializzazione del miglior valore di regressione 
% individuato dal sistema
b_reg = 0; 
found = 0;
k=0;
while(found == 0)

    
	% Create a Fitting Network 
	hiddenLayerSize = INIT_HIDDEN_LAYER + k;

	net = fitnet(hiddenLayerSize);


	% Setup Division of Data for Training, Validation, Testing
	net.divideParam.trainRatio = 70/100;
	net.divideParam.valRatio = 15/100;
	net.divideParam.testRatio = 15/100;

	for i=1:MAX_RIP
		net = init(net);
		% Train the Network
		[net,tr] = train(net,inputs,targets);

		% Test the Network
		outputs = net(inputs);
		errors = gsubtract(targets,outputs);
		performance = perform(net,targets,outputs);

		% Una volta concluso l'addestramento mi ricavo e analizzo i parametri
		% che a me interessano del sistema
		err = Errhis(errors);
		reg = Regres(targets,outputs)
        b_reg
        best_err = abs(b_err)
        err = abs(err)
    		if (abs(err) <= MAX_ERR  && reg >= MIN_REG) 
        		found=1;
        		b_tr = tr;
        		b_outputs = outputs;
        		b_errors = errors;
        		b_err = err;
       	 		b_reg = reg;
        		break; 
    		end
    
    		if (abs(err) < abs(b_err) && reg > b_reg)
        
        		b_tr = tr;
        		b_outputs = outputs;
        		b_errors = errors
        		b_err = err;
        		b_reg = reg;
    		end
    
    
	end
	k = k+1;

    	if (k == (MAX_HID_LAYER - INIT_HIDDEN_LAYER))
        	found = 1;
    	end
end

% View the Network
view(net)

% Plots

figure, plotperform(b_tr)
figure, plotregression(targets,b_outputs)
figure, ploterrhist(b_errors)