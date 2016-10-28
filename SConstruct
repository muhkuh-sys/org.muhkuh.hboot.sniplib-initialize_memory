# -*- coding: utf-8 -*-

#----------------------------------------------------------------------------
#
# Set up the Muhkuh Build System.
#
SConscript('mbs/SConscript')
Import('env_default')

# Create a build environment for the ARM9 based netX chips.
env_arm9 = env_default.CreateEnvironment(['gcc-arm-none-eabi-4.7', 'asciidoc'])

# Create a build environment for the Cortex-R based netX chips.
env_cortex7 = env_default.CreateEnvironment(['gcc-arm-none-eabi-4.9', 'asciidoc'])


#----------------------------------------------------------------------------
#
# Create the compiler environments.
#
astrIncludePaths = ['src', '#platform/src', '#platform/src/lib', '#targets/version']


env_netx4000_default = env_cortex7.CreateCompilerEnv('4000', ['arch=armv7', 'thumb'], ['arch=armv7-r', 'thumb'])
env_netx4000_default.Append(CPPPATH = astrIncludePaths)
env_netx4000_default.Replace(BOOTBLOCK_CHIPTYPE = 4000)

env_netx56_default = env_arm9.CreateCompilerEnv('56', ['arch=armv5te'])
env_netx56_default.Append(CPPPATH = astrIncludePaths)
env_netx56_default.Replace(BOOTBLOCK_CHIPTYPE = 56)

Export('env_netx4000_default', 'env_netx56_default')


#----------------------------------------------------------------------------
# This is the list of sources. The elements must be separated with whitespace
# (i.e. spaces, tabs, newlines). The amount of whitespace does not matter.
sources = """
	src/fill.S
"""


#----------------------------------------------------------------------------
#
# Build all files.
#
# netX4000 CR7
env_netx4000_cr7 = env_netx4000_default.Clone()
env_netx4000_cr7.Replace(LDFILE = 'src/netx4000/netx4000_cr7.ld')
src_netx4000_cr7 = env_netx4000_cr7.SetBuildPath('targets/netx4000_cr7', 'src', sources)
elf_netx4000_cr7 = env_netx4000_cr7.Elf('targets/netx4000_cr7/netx4000_cr7.elf', src_netx4000_cr7)
txt_netx4000_cr7 = env_netx4000_cr7.ObjDump('targets/netx4000_cr7/netx4000_cr7.txt', elf_netx4000_cr7, OBJDUMP_FLAGS=['--disassemble', '--source', '--all-headers', '--wide'])
bin_netx4000_cr7 = env_netx4000_cr7.ObjCopy('targets/netx4000_cr7/netx4000_cr7.bin', elf_netx4000_cr7)

tmp_netx4000_cr7 = env_netx4000_cr7.Version('targets/netx4000_cr7/snippet_tmp.xml', 'templates/hboot_snippet.xml')
snip_netx4000_cr7 = env_netx4000_cr7.GccSymbolTemplate('targets/netx4000_cr7/snippet.xml', elf_netx4000_cr7, GCCSYMBOLTEMPLATE_TEMPLATE=tmp_netx4000_cr7[0], GCCSYMBOLTEMPLATE_BINFILE=bin_netx4000_cr7[0])

# Create the snippet from the parameters.
global PROJECT_VERSION
aArtifactGroupReverse = ['org', 'muhkuh', 'hboot', 'sniplib']
atSnippet = {
    'group': '.'.join(aArtifactGroupReverse),
    'artifact': 'initialize_memory',
    'version': PROJECT_VERSION,
    'vcs_id': env_netx4000_cr7.Version_GetVcsId(),
    'vcs_url': env_netx4000_cr7.Version_GetVcsUrl(),
    'license': 'GPL-2.0',
    'author_name': 'Muhkuh team',
    'author_url': 'https://github.com/muhkuh-sys',
    'description': File('src/netx4000/snippet.dsc'),
    'categories': ['netx4000', 'memory'],
    'parameter': {
        'START': {'help': 'The first address to fill. Must be a multiple of 4.'},
        'END': {'help': 'The last address to fill + 4. Must be a multiple of 4.'},
        'FILL': {'help': 'The fill value. This is a 32bit value, so 0x12 will result in 0x12 0x00 0x00 0x00 0x12 ...', 'default': 0}
    }
}
strArtifactPath = 'targets/snippets/%s/%s/%s' % ('/'.join(aArtifactGroupReverse), atSnippet['artifact'], PROJECT_VERSION)
snippet_netx4000_cr7 = env_netx4000_cr7.HBootSnippet('%s/%s-%s.xml' % (strArtifactPath, atSnippet['artifact'], PROJECT_VERSION), snip_netx4000_cr7, PARAMETER=atSnippet)

# Create the POM file.
tPOM = env_netx4000_cr7.POMTemplate('%s/%s-%s.pom' % (strArtifactPath, atSnippet['artifact'], PROJECT_VERSION), 'templates/pom.xml', POM_TEMPLATE_GROUP=atSnippet['group'], POM_TEMPLATE_ARTIFACT=atSnippet['artifact'], POM_TEMPLATE_VERSION=atSnippet['version'], POM_TEMPLATE_PACKAGING='xml')
