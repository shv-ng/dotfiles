local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
	pattern = "*",
	callback = function()
		vim.lsp.buf.format()
	end,
})
vim.cmd([[
    command! FormatAll lua vim.lsp.buf.format({async = true})
]])
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")
