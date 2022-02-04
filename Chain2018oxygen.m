%% Kilpis Oxy
% Kilpisjärvi chain 2018, data from Zebra D-Opto oxygen loggers
% for metadata see 2018 recovery_&_deployment_comments.xlsx
%
%% ID's and depth levels Kilpis 2018
% logger IDs
id0 = [8 9 10 11 12 13 14 15 16 17 18 20 22 24 28 32 33 34  35 36 37 38 39 40]';
idDO=[2476 2576 2600 2601 2604 2612 2613 2614 2615 2616 2617 2618 2619 2621 2623 2625 2641 2475 2632 2624 2620 2636 2639 2642]';
%
bouyDepth = 2;% m
zBuoy = [6.3 7.3 8.4 9.45 10.5 11.55 12.55 13.55 14.6 15.7 16.7 18.75 20.8 22.9 27.05 31.1 32.15 33.15 34.2 35.2 36.25 37.3 38.35 40.35]';
zDO = zBuoy + bouyDepth;

% old values
%idDO=[ 2476 2576  2601 2604 2612 2613 2614 2615 2616 2617 2618 2619 2621 2623 ...
%    2625 2641 2475 2632 2624 2620 2636 2639]';
%zDO=[8.3 9.3  11.45 12.5 13.55 14.55 15.55 16.6 17.7 18.7 20.75 22.8 24.9 ...
%    29.05 32.15 33.1 34.15 35.15 36.2 37.2 38.25 39.3 40.35]';

%% read ASCII data files 
for ii=1:length(idDO)
    DO{ii}=readZebra([num2str(id0(ii),'%02d'), '_', num2str(idDO(ii)), '.dat']);
    d1=datenum('18 jan 2018 00:00');
    d2=datenum('26 aug 2018 00:00');
    DOsat(:,ii)=DO{ii}.dosat(DO{ii}.dates>=d1&DO{ii}.dates<d2);
    DOmg(:,ii)=DO{ii}.domg(DO{ii}.dates>=d1&DO{ii}.dates<d2);
    Tdo(:,ii)=DO{ii}.T(DO{ii}.dates>=d1&DO{ii}.dates<d2);
end
% calculate dates
datesDO=DO{ii}.dates(DO{ii}.dates>=d1&DO{ii}.dates<d2);
% remove outliers (bad values)
DOmg(DOsat<0) = nan;
Tdo(DOsat<0) = nan;
DOsat(DOsat<0) = nan;
DOsat=medfilt1((DOsat),3);
DOmg = medfilt1((DOmg),3);
Tdo = medfilt1((Tdo),3);
%DepthA=41.8;% approximate depth from RBR TD
DepthDO= zDO;
%% Oxygen saturation, line plot
clf
plot(datesDO,((DOsat))),datetick

%% plot temperature and oxygen
make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.0 0.0], [0.1 0.05], [0.1 0.05]);
if ~make_it_tight,  clear subplot;  end
subplot(2,1,1)
plot(datesDO,Tdo(:,[1 3:3:15 end-3:end]));
%set(gca,'xlim',[datenum('15 jan 2014') datenum('15 jul 2014')],...
%    'xticklabel',[])
datetick('keeplimits')
ylabel('Temperature, ^{o}C')
legend(strcat(num2str(DepthDO([1 3:3:15 end-3:end])),' m'),...
    'location', 'northwest');
legend boxoff
title('Kilpisjärvi 2018, total depth 42 m')
subplot(2,1,2)
plot(datesDO,DOmg(:,[1 3:3:15 end-3:end]));
ylabel('DO, mg l^{-1}')
%set(gca,'xlim',[datenum('15 jan 2014') datenum('15 jul 2014')],'ylim',[9 13],...
%    'ytick',[10:12])
datetick('keeplimits')
%% Oxygen concentration, contour plot
% deep mixing in spring - late june
%figure
clf
contourf(datesDO,-zDO,DOmg',[4:.25:13],'linestyle','none'),datetick,
colormap jet
colormap(flipud(colormap))
caxis([6 12])
hold on
contour(datesDO,-zDO,DOmg',[6:1:10],'color','w'),datetick
set(gca,'xlim',[datenum('16 jan 2018') datenum('26 aug 2018')], 'ylim',[-42 -10])
ylabel('Depth, m')
xlabel('Date')
hb=colorbar;
set(get(hb,'ylabel'),'string','DO, mg\cdot l^{-1}')
title('Kilpisjärvi 2018, DO concentration')
%set(gca,'ylim',[0 10])
%% Temperature, contour plot
% deep mixing in spring - late june
%figure
clf
contourf(datesDO,-zDO,Tdo',[0:.25:16],'linestyle','none'),datetick
%colorbar
hold on
contour(datesDO,-zDO,Tdo',[0:2:16],'color','w'),datetick
load cmap
colormap(sst)
hb=cbarf([0 16],[0:.25:16]);
set(gca,'xlim',[datenum('16 jan 2018') datenum('26 aug 2018')], 'ylim',[-42 -10])
ylabel('Depth, m')
xlabel('Date')
hb=colorbar;
set(get(hb,'ylabel'),'string','T, ^{o}C')
title('Kilpisjärvi 2018, Water temperature')


%% export xls
DOdates24=(nmean(datesDO,round(1/diff(datesDO(1:2)))));
Tdo24=(nmean(Tdo,round(1/diff(datesDO(1:2)))));
DOmg24=(nmean(DOmg,round(1/diff(datesDO(1:2)))));
DOsat24=(nmean(DOsat,round(1/diff(datesDO(1:2)))));

T = array2table([str2num(datestr(DOdates24,'yyyymmdd')) Tdo24(:,1) Tdo24(:,end)...
    DOmg24(:,1) DOmg24(:,end) DOsat24(:,1) DOsat24(:,end)]);
writetable(T,'DO24kilpis2018','filetype','spreadsheet')
%xlswrite('DO24kilpis2018',[str2num(datestr(DOdates24,'yyyymmdd')) Tdo24(:,1) Tdo24(:,end)...
%    DOmg24(:,1) DOmg24(:,end) DOsat24(:,1) DOsat24(:,end)]);

%%

