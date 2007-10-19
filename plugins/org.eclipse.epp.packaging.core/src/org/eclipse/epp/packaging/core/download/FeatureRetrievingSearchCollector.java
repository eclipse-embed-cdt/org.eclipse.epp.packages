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
package org.eclipse.epp.packaging.core.download;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.update.core.IFeature;
import org.eclipse.update.core.VersionedIdentifier;
import org.eclipse.update.search.IUpdateSearchResultCollector;

/** 
 * An UpdateSearchResultCollector returning a feature.
 */
public class FeatureRetrievingSearchCollector
  implements IUpdateSearchResultCollector
{

  private final List<IFeature> features = new ArrayList<IFeature>();
  private final List<VersionedIdentifier> identifiers = new ArrayList<VersionedIdentifier>();

  public void accept( final IFeature match ) {
    if( !this.identifiers.contains( match.getVersionedIdentifier() ) ) {
      this.features.add( match );
      this.identifiers.add( match.getVersionedIdentifier() );
    }
  }

  public IFeature[] getFeatures() {
    return this.features.toArray( new IFeature[ this.features.size() ] );
  }
}
