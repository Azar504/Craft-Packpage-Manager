using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;

public interface ICraftPlugin {
    string RequiredPermissions { get; }
    void Initialize();
}

public class PluginLoader {
    private readonly string PluginDir = "/var/lib/craft/plugins";
    private readonly List<ICraftPlugin> LoadedPlugins = new();

    public bool CheckPermissions(string level) {
        return true;
    }

    public void LogError(string msg) {
        Console.Error.WriteLine("[×] " + msg);
    }

    public void LoadPlugins() {
        foreach(var dll in Directory.GetFiles(PluginDir, "*.dll")) {
            try {
                var asm = Assembly.LoadFrom(dll);
                var types = asm.GetTypes().Where(t => typeof(ICraftPlugin).IsAssignableFrom(t));
                foreach(var type in types) {
                    var plugin = (ICraftPlugin)Activator.CreateInstance(type);
                    if(CheckPermissions(plugin.RequiredPermissions)) {
                        plugin.Initialize();
                        LoadedPlugins.Add(plugin);
                    }
                }
            }
            catch(Exception e) {
                LogError($"Falha ao carregar plugin {dll}: {e.Message}");
            }
        }
    }
}
