function savefig(filename, figdir, previewdir)
  DEFAULT_FIGDIR = '../Journal/figs/';
  DEFAULT_PREVIEWDIR = '../Journal/figs/Preview/';

  if nargin < 2
    figdir = DEFAULT_FIGDIR;
  end

  if nargin < 3
    previewdir = DEFAULT_PREVIEWDIR;
  end

  saveas(gcf, [figdir filename], 'epsc')
  saveas(gcf, [previewdir filename], 'png')
end