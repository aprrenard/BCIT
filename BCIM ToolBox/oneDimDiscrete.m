function oneDimDiscrete
% Create Figure Window
% Create Figure Window
figSize = [1 1]; % 1st element width, 2nd height
figPos = [0 0]; % 1st element x, 2nd y
figure2 = figure('NumberTitle', 'off');
set(gcf,'WindowStyle', 'normal','units','normalized','Position',[figPos figSize],...
    'toolbar','none','menu','none','name','BCI Toolbox: One-Dimension Discrete')

%%% Create Radio Buttons
settings = uipanel('Title','Settings','FontSize',15,'Position',[0.53 0.65 0.45 0.2]);
parentColor = get(get(settings,'parent'),'color');
set(settings,'BackgroundColor',parentColor);

% type of plot
uicontrol('parent',settings,'Style','text','units','normalized','FontSize',12,...
    'Position',[0.0,0.63,0.2,0.2],'String','Model Elements','backgroundcolor', parentColor);
posterior_check = uicontrol('parent',settings,'style','checkbox','units','normalized',...
    'position',[0.25,0.7,0.3,0.15],'string','Resp. Distribution','Value',1,...
    'FontSize',13,'backgroundcolor', parentColor,'Callback',@slider_callback);

% display
uicontrol('parent',settings,'Style','text','units','normalized','FontSize',12,...
    'Position',[0,0.3,0.2,0.25],'String','Model Estimates','backgroundcolor', parentColor);
mode_check = uicontrol('parent',settings,'style','checkbox','units','normalized',...
    'position',[0.25,0.4,0.3,0.2],'string','Mode','Value',1,...
    'FontSize',13,'backgroundcolor', parentColor,'Callback',@slider_callback);
mean_check= uicontrol('parent',settings,'style','checkbox','units','normalized',...
    'position',[0.48,0.4,0.3,0.2],'string','Mean',...
    'FontSize',13,'backgroundcolor', parentColor,'Callback',@slider_callback);

% strategies
uicontrol('parent',settings,'Style','text','units','normalized','FontSize',13,...
    'Position',[0,0.04,0.2,0.25],'String','Decision Strategies','backgroundcolor', parentColor);
selection = uicontrol('parent',settings,'style','radio','units','normalized',...
    'position',[0.25,0.1,0.3,0.2],'string','Model Selection',...
    'FontSize',13,'backgroundcolor', parentColor,'Callback',@set_mutually_exclusive);
averaging = uicontrol('parent',settings,'style','radio','units','normalized',...
    'position',[0.48,0.1,0.3,0.2],'string','Model Averaging','Value',1,...
    'FontSize',13,'backgroundcolor', parentColor,'Callback',@set_mutually_exclusive);
matching = uicontrol('parent',settings,'style','radio','units','normalized',...
    'position',[0.7,0.1,0.3,0.2],'string','Probability Matching',...
    'FontSize',13,'backgroundcolor', parentColor,'Callback',@set_mutually_exclusive);

set(selection,'Userdata',[averaging matching]);
set(averaging,'Userdata',[selection matching]);
set(matching,'Userdata',[selection averaging]);

%%% Create Sliders
% stimulus properties
stimulus = uipanel('Title','Stimulus','FontSize',15,...
    'Position',[0.53 0.48 0.45 0.15],'backgroundcolor',parentColor);

% choose the location of stimulus
uicontrol('parent',stimulus,'Style','text','units','normalized','FontSize',12,...
    'Position',[0.02,0.6,0.15,0.2],'String','Stimulus 1','ForegroundColor','b','backgroundcolor',parentColor);
popup1 = uicontrol('parent',stimulus,'style','popup','units','normalized',...
    'position',[0.2,0.8,0.3,0.05],'string',{'0','1','2','3','4'},'value',2,...
    'callback',{@slider_callback});
uicontrol('parent',stimulus,'Style','text','units','normalized','FontSize',12,...
    'Position',[0.02,0.2,0.15,0.2],'String','Stimulus 2','ForegroundColor','r','backgroundcolor',parentColor);
popup2 = uicontrol('parent',stimulus,'style','popup','units','normalized',...
    'position',[0.2,0.4,0.3,0.05],'string',{'0','1','2','3','4'},'value',5,...
    'callback',{@slider_callback});


% parameters
parameters = uipanel('Title','Parameters','FontSize',15,...
    'Position',[0.53 0.15 0.45 0.3],'BackgroundColor',parentColor);
cf = 0.15/0.25;

% slider 1
v1_bnd = [0 1]; slmin = 0; slmax = 1; v1_start = 0.5;
annotation(parameters,'textbox',[0.02,0.8,0.15,0.2*cf],'FontSize',18,...
    'String','$P(C=1)$','interpreter','latex','linestyle','none','fontweight','bold');
slider1 = uicontrol('parent',parameters,'style','slider','Min',slmin,'Max',slmax,...
    'SliderStep',[0.01 0.01],'Value',v1_start,'units','normalized',...
    'position',[0.3,0.8,0.6,0.2*cf],'Callback',{@slider_callback});
box1 = uicontrol('parent',parameters,'Style','edit','units','normalized',...
    'position',[0.18,0.8,0.1,0.2*cf],'String',num2str(v1_start),'Callback',@box_callback);

% slider 2
v2_bnd = [.1 5]; slmin = 0.1; slmax = 50; v2_start = 2;
annotation(parameters,'textbox',[0.02,0.64,0.15,0.2*cf],'FontSize',22,'color','b',...
    'String','$\sigma_1$','interpreter','latex','linestyle','none','fontweight','bold');
slider2 = uicontrol('parent',parameters,'style','slider','Min',slmin,'Max',slmax,...
    'SliderStep',[0.1 0.1]./(slmax-slmin),'Value',v2_start,'units','normalized',...
    'position',[0.3,0.64,0.6,0.2*cf],'Callback',{@slider_callback});
box2 = uicontrol('parent',parameters,'Style','edit','units','normalized',...
    'position',[0.18,0.64,0.1,0.2*cf],'String',num2str(v2_start),'Callback',@box_callback);

% slider 3
v3_bnd = [.1 5]; slmin = 0.1; slmax = 50; v3_start = .5;
annotation(parameters,'textbox',[0.02,0.46,0.15,0.2*cf],'FontSize',22,'color','r',...
    'String','$\sigma_2$','interpreter','latex','linestyle','none','fontweight','bold');
slider3 = uicontrol('parent',parameters,'style','slider','Min',slmin,'Max',slmax,...
    'SliderStep',[0.1 0.1]./(slmax-slmin),'Value',v3_start,'units','normalized',...
    'position',[0.3,0.46,0.6,0.2*cf],'Callback',{@slider_callback});
box3 = uicontrol('parent',parameters,'Style','edit','units','normalized',...
    'position',[0.18,0.46,0.1,0.2*cf],'String',num2str(v3_start),'Callback',@box_callback);


% slider 4
v4_bnd = [.1 50]; slmin = 0.1; slmax = 50; v4_start = 5;
annotation(parameters,'textbox',[0.02,0.28,0.15,0.2*cf],'FontSize',22,'color',[0.4660 0.6740 0.1880],...
    'String','$\sigma_{Prior}$','interpreter','latex','linestyle','none','fontweight','bold');
slider4 = uicontrol('parent',parameters,'style','slider','Min',slmin,'Max',slmax,...
    'SliderStep',[.1 .1]./(slmax-slmin),'Value',v4_start,'units','normalized',...
    'position',[0.3,0.28,0.6,0.2*cf],'Callback',{@slider_callback});
box4 = uicontrol('parent',parameters,'Style','edit','units','normalized',...
    'position',[0.18,0.28,0.1,0.2*cf],'String',num2str(v4_start),'Callback',@box_callback);


% slider 5
v5_bnd = [0 5]; slmin = 0; slmax = 4; v5_start = 2;
annotation(parameters,'textbox',[0.02,0.1,0.15,0.2*cf],'FontSize',22,'color',[0.4660 0.6740 0.1880],...
    'String','$\mu_{Prior}$','interpreter','latex','linestyle','none','fontweight','bold');
slider5 = uicontrol('parent',parameters,'style','slider','Min',slmin,'Max',slmax,...
    'SliderStep',[.1 .1]./(slmax-slmin),'Value',v5_start,'units','normalized',...
    'position',[0.3,0.1,0.6,0.2*cf],'Callback',{@slider_callback});
box5 = uicontrol('parent',parameters,'Style','edit','units','normalized',...
    'position',[0.18,0.1,0.1,0.2*cf],'String',num2str(v5_start),'Callback',@box_callback);


%%% Add a title
% uicontrol('Style','text','units','normalized',...
%     'Position',[0.06,0.9,0.4,0.04],'String','One-dimension Plot of Discrete Estimates',...
%     'FontSize',18, 'backgroundcolor', parentColor);

%%% save & return button
uicontrol('style','pushbutton','units','normalized',...
    'position',[0.55,0.05,0.1,0.08],'string','Screenshot',...
    'FontSize',13,'callback',@save);
uicontrol('style','pushbutton','units','normalized',...
    'position',[0.7,0.05,0.1,0.08],'string','Reset to Default',...
    'FontSize',13,'callback',@reset);
uicontrol('style','pushbutton','units','normalized',...
    'position',[0.85,0.05,0.1,0.08],'string','Main Menu',...
    'FontSize',13,'callback',@returnToMain);

% Store gui data for later use
slider_callback(figure2,1);

    function save(~,~)
        answer = inputdlg('Screenshot Name?');
        if ~isempty(answer)
            saveas(figure2,answer{1});
        end
    end

    function reset(varargin)
        set(box1, 'String', v1_start);
        set(box2, 'String', v2_start);
        set(box3, 'String', v3_start);
        set(box4, 'String', v4_start);
        set(box5, 'String', v5_start);
        set(slider1,'Value',v1_start);
        set(slider2,'Value',v2_start);
        set(slider3,'Value',v3_start);
        set(slider4,'Value',v4_start);
        set(slider5,'Value',v5_start);
        set(posterior_check,'Value',1);
        set(likelihood_check,'value',0);
        set(prior_check,'value',0);
        set(averaging,'Value',1);
        set(matching,'Value',0);
        set(selection,'Value',0);
        set(mode_check,'Value',1);
        set(mean_check,'Value',0);
        set(popup1,'Value',2);
        set(popup2,'Value',5);
        slider_callback;
    end

    function returnToMain(varargin)
        close(figure2);
    end

    function slider_callback(~,~)
        pos1 = get(popup1,'value')-1;
        pos2 = get(popup2,'value')-1;
        
        v1 = get(slider1, 'Value');
        v2 = get(slider2, 'Value');
        v3 = get(slider3, 'Value');
        v4 = get(slider4, 'Value');
        v5 = get(slider5, 'Value');
        
        set(box1,'String',v1);
        set(box2,'String',v2);
        set(box3,'String',v3);
        set(box4,'String',v4);
        set(box5,'String',v5);
        
        bciPlot(v1,pos1,pos2,v2,v3,v4,v5);
    end


    function box_callback(varargin)
        if all(ismember(varargin{1}.String, '-.1234567890'))
            v1 = str2double(get(box1, 'String'));
            v2 = str2double(get(box2, 'String'));
            v3 = str2double(get(box3, 'String'));
            v4 = str2double(get(box4, 'String'));
            v5 = str2double(get(box5, 'String'));
            
            v1 = (v1>v1_bnd(2))*v1_bnd(2) + (v1<=v1_bnd(2))*v1;
            v1 = (v1<v1_bnd(1))*v1_bnd(1) + (v1>=v1_bnd(1))*v1;
            v2 = (v2>v2_bnd(2))*v2_bnd(2) + (v2<=v2_bnd(2))*v2;
            v2 = (v2<v2_bnd(1))*v2_bnd(1) + (v2>=v2_bnd(1))*v2;
            v3 = (v3>v3_bnd(2))*v3_bnd(2) + (v3<=v3_bnd(2))*v3;
            v3 = (v3<v3_bnd(1))*v3_bnd(1) + (v3>=v3_bnd(1))*v3;
            v4 = (v4>v4_bnd(2))*v4_bnd(2) + (v4<=v4_bnd(2))*v4;
            v4 = (v4<v4_bnd(1))*v4_bnd(1) + (v4>=v4_bnd(1))*v4;
            v5 = (v5>v5_bnd(2))*v5_bnd(2) + (v5<=v5_bnd(2))*v5;
            v5 = (v5<v5_bnd(1))*v5_bnd(1) + (v5>=v5_bnd(1))*v5;
            
            set(box1, 'String', num2str(v1));
            set(box2, 'String', num2str(v2));
            set(box3, 'String', num2str(v3));
            set(box4, 'String', num2str(v4));
            set(box5, 'String', num2str(v5));
            
            set(slider1,'Value',v1);
            set(slider2,'Value',v2);
            set(slider3,'Value',v3);
            set(slider4,'Value',v4);
            set(slider5,'Value',v5);
            
            slider_callback;
            
        else
            warndlg('Input must be numeric');
        end
    end

    function bciPlot(v1,pos1,pos2,v3,v4,v5,v6)
        % specify the location of the figure
        f = subplot(1,2,1);
        size = get(f,'Position');
        set(f,'Position',size + [-0.08 0 0.12 -0.08]);
        
        [x,freq_predV_bi,freq_predT_bi] = bciModel([v1,pos1,pos2,v3,v4,v5,v6]);
        hold on;
        
        % true position
        upper_margin = 0.1+max([freq_predV_bi,freq_predT_bi]);
        axis([min(x)-.5 max(x)+.5 0 max([freq_predV_bi,freq_predT_bi])+upper_margin])
        p1 = line([pos1 pos1]',[0 max([freq_predV_bi,freq_predT_bi])+upper_margin]',...
            'LineWidth',2,'LineStyle','--','Color','b');hold on
        p2 = line([pos2 pos2]',[0 max([freq_predV_bi,freq_predT_bi])+upper_margin]',...
            'LineWidth',2,'LineStyle','--','Color','r');
        legend_strs = {'Stimulus 1','Stimulus 2'};
        legend_vars = [p1 p2];
        xlabel('Discrete Space (Arbitrary Units)', 'Fontsize', 16);
        ylabel('Probabilty', 'Fontsize', 16);
        set(gca,'fontsize',16,'XTick',x);
        
        % posterior
        if get(posterior_check,'Value')==1
            p3 = bar(x,freq_predV_bi,'FaceColor','b','BarWidth',1,'LineWidth', 2);
            p4 = bar(x,freq_predT_bi,'FaceColor','r','BarWidth',0.75,'LineWidth', 2);
            legend_strs(end+1:end+2) = {'Resp. Distribution 1','Resp. Distribution 2'};
            legend_vars(end+1:end+2) = [p3 p4];
        end
        
        % max estimates
        if get(mode_check,'Value')==1
            est_V = max(freq_predV_bi);
            est_T = max(freq_predT_bi);
            p5 = plot(x(find(freq_predV_bi==est_V,1)),est_V,'bd','MarkerFaceColor','b','MarkerSize',12,'MarkerEdgeColor','k');
            p6 = plot(x(find(freq_predT_bi==est_T,1)),est_T,'rd','MarkerFaceColor','r','MarkerSize',12,'MarkerEdgeColor','k');
            legend_strs(end+1:end+2) = {'Mode 1','Mode 2'};
            legend_vars(end+1:end+2) = [p5 p6];
        end
        
        % mean estimates
        if get(mean_check,'Value')==1
            vX = round(sum(x.*freq_predV_bi));
            tX = round(sum(x.*freq_predT_bi));
            vY = spline(x, freq_predV_bi, vX);
            tY = spline(x, freq_predT_bi, tX);
            p7 = plot(vX,vY, 'bs','MarkerFaceColor','b','MarkerSize',12,'MarkerEdgeColor','k');
            p8 = plot(tX,tY, 'rs','MarkerFaceColor','r','MarkerSize',12,'MarkerEdgeColor','k');
            legend_strs(end+1:end+2) = {'Mean 1','Mean 2'};
            legend_vars(end+1:end+2) = [p7 p8];
        end
        
        % legend
        legend(legend_vars,legend_strs,'Location',[0.07,0.73,0.1,0.1])
        hold off;
        
    end

    function [x,freq_predV_bi,freq_predT_bi] = bciModel(params)
        lowerBnd = 0; upperBnd = 5; numBins = 6;
        x = linspace(lowerBnd,upperBnd,numBins); % discretizing the space
        N = 10000;
        p_common = params(1);
        posV = params(2);
        posT = params(3);
        sigV = params(4); varV = sigV^2;
        sigT = params(5); varT = sigT^2;
        sigP = params(6); varP = sigP^2;
        xP = params(7);
        var_common = varV * varT + varV * varP + varT * varP;
        varVT_hat = 1/(1/varV + 1/varT + 1/varP);
        varV_hat = 1/(1/varV + 1/varP);
        varT_hat = 1/(1/varT + 1/varP);
        varV_indep = varV + varP;
        varT_indep = varT + varP;
        trueV = posV;
        trueT = posT;
        xV = bsxfun(@plus, trueV, sigV * randn(N,1));
        xT = bsxfun(@plus, trueT, sigT * randn(N,1));
        quad_common = (xV-xT).^2 * varP + (xV-xP).^2 * varT + (xT-xP).^2 * varV;
        quadV_indep = (xV-xP).^2;
        quadT_indep = (xT-xP).^2;
        likelihood_common = exp(-quad_common/(2*var_common))/(2*pi*sqrt(var_common));
        likelihoodV_indep = exp(-quadV_indep/(2*varV_indep))/sqrt(2*pi*varV_indep);
        likelihoodT_indep = exp(-quadT_indep/(2*varT_indep))/sqrt(2*pi*varT_indep);
        likelihood_indep =  likelihoodV_indep .* likelihoodT_indep;
        post_common = likelihood_common * p_common;
        post_indep = likelihood_indep * (1-p_common);
        pC = post_common./(post_common + post_indep);
        s_hat_common = ((xV/varV) + (xT/varT) + repmat(xP,N,1)/varP) * varVT_hat;
        sV_hat_indep = ((xV/varV) + repmat(xP,N,1)/varP) * varV_hat;
        sT_hat_indep = ((xT/varT) + repmat(xP,N,1)/varP) * varT_hat;
        
        if get(selection, 'Value')
            sV_hat_bi = (pC>0.5).*s_hat_common + (pC<=0.5).*sV_hat_indep;
            sT_hat_bi = (pC>0.5).*s_hat_common + (pC<=0.5).*sT_hat_indep;
        elseif get(averaging, 'Value')
            sV_hat_bi = (pC).*s_hat_common + (1-pC).*sV_hat_indep;
            sT_hat_bi = (pC).*s_hat_common + (1-pC).*sT_hat_indep;
        elseif get(matching, 'Value')
            match = 1 - rand(N, 1);
            sV_hat_bi = (pC>match).*s_hat_common + (pC<=match).*sV_hat_indep;
            sT_hat_bi = (pC>match).*s_hat_common + (pC<=match).*sT_hat_indep;
        end
        
        h = hist(round(sV_hat_bi), x);
        freq_predV_bi = bsxfun(@rdivide,h,sum(h));
        h = hist(round(sT_hat_bi), x);
        freq_predT_bi = bsxfun(@rdivide,h,sum(h));
    end

    function set_mutually_exclusive(varargin)
        current_obj = gcbo;
        objs_to_turn_off = get(current_obj,'Userdata');
        set(current_obj,'Value',1)
        set(objs_to_turn_off,'Value',0)
        slider_callback(gcbo);
    end
end