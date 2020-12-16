function savefig(filename, figdir, previewdir, target)
  DEFAULT_FIGDIR = '../Journal/figs/';
  DEFAULT_PREVIEWDIR = '../Journal/figs/Preview/';
  DEFAULT_TARGET = gcf;

  if nargin < 2 || isempty(figdir)
    figdir = DEFAULT_FIGDIR;
  end

  if nargin < 3 || isempty(previewdir)
    previewdir = DEFAULT_PREVIEWDIR;
  end

  if nargin < 4
    target = DEFAULT_TARGET;
  end

  saveas(target, [figdir filename], 'epsc')
  saveas(target, [previewdir filename], 'png')
end