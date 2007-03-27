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

import org.eclipse.update.core.VersionedIdentifier;
import org.eclipse.update.search.IUpdateSearchCategory;
import org.eclipse.update.search.IUpdateSearchQuery;

/**An UpdateSearchCategory looking for feature identifiers*/
public class PackagerSearchCategory implements IUpdateSearchCategory {

  private final PackagerSearchQuery query = new PackagerSearchQuery();
  private String id;

  public String getId() {
    return id;
  }

  /**Adds a feature to search for.*/
  public void addFeatureToSearch( final VersionedIdentifier identifier ) {
    query.addFeatureIdentifier( identifier );
  }

  public IUpdateSearchQuery[] getQueries() {
    return new IUpdateSearchQuery[]{
      query
    };
  }

  public void setId( final String id ) {
    this.id = id;
  }
}
