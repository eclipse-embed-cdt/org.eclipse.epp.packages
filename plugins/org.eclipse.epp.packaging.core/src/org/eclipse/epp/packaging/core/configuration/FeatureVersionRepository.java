/*******************************************************************************
 * Copyright (c) 2007 Innoopract Informationssysteme GmbH
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Innoopract - initial API and implementation
 *******************************************************************************/
package org.eclipse.epp.packaging.core.configuration;

import java.util.HashMap;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

import org.eclipse.core.runtime.PluginVersionIdentifier;
import org.eclipse.update.core.VersionedIdentifier;
import org.osgi.framework.Version;


/**
 *
 */
public class FeatureVersionRepository {

  private Map<String, VersionList> features = new HashMap<String, VersionList>();

  public void addVersionIdentifier( final VersionedIdentifier versionedIdentifier ) {
    String identifier = versionedIdentifier.getIdentifier();
    PluginVersionIdentifier version = versionedIdentifier.getVersion();
    if( !this.features.containsKey( identifier ) ) {
      this.features.put( identifier, new VersionList() );
    }
    VersionList versionList = this.features.get( identifier );
    versionList.addVersion( version );
  }
  
  /**
   * Searches for the highest version number of a given feature or bundle,
   * identified by the identifier string.
   * 
   * @param identifier of the feature
   * @return the highest available version number or <code>null</code> if the
   *         identifier is not found.
   */
  public PluginVersionIdentifier getHighestVersion( final String identifier ) {
    PluginVersionIdentifier result = null;
    VersionList versionList = this.features.get( identifier );
    if( versionList != null ) {
      result = versionList.getHighestVersion();
    }
    return result;
  }
  
  /**
   * Checks if a given identifier is already in the list of available features.
   * 
   * @param identifier String with the feature identifier.
   * @return <code>true</code> if the identifier is found in the list of
   *         available features, <code>false</code> otherwise.
   */
  public boolean containsIdentifier( final String identifier ) {
    return this.features.containsKey( identifier );
  }
  
  
  /**
   * This class provides a modifiable list of
   * <code>PluginVersionIdentifier</code> and returns the highest possible
   * version number. Internally it uses the OSGi <code>Version</code>
   * implementation because of its <code>Comparable</code> interface.
   */
  class VersionList {

    private SortedSet<Version> versions = new TreeSet<Version>();

    /**
     * Adds a new version to the list of available versions if the version is
     * not yet included in the list.
     * 
     * @param versionIdentifier the version that is to be added to the list
     */
    void addVersion( final PluginVersionIdentifier versionIdentifier ) {
      Version version = new Version( versionIdentifier.getMajorComponent(),
                                     versionIdentifier.getMinorComponent(),
                                     versionIdentifier.getServiceComponent(),
                                     versionIdentifier.getQualifierComponent() );
      if( !this.versions.contains( version ) ) {
        this.versions.add( version );
      }
    }

    /**
     * @return the highest version number in the list
     */
    PluginVersionIdentifier getHighestVersion() {
      return new PluginVersionIdentifier( this.versions.last().toString() );
    }
  }
}
