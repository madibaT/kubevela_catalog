package main

kustomizeCRD: {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.12.0"
		labels: {
			"app.kubernetes.io/component": "kustomize-controller"
			"app.kubernetes.io/instance":  "flux-system"
			"app.kubernetes.io/part-of":   "flux"
			"app.kubernetes.io/version":   "v2.1.0"
		}
		name: "kustomizations.kustomize.toolkit.fluxcd.io"
	}
	spec: {
		group: "kustomize.toolkit.fluxcd.io"
		names: {
			kind:     "Kustomization"
			listKind: "KustomizationList"
			plural:   "kustomizations"
			shortNames: [
				"ks",
			]
			singular: "kustomization"
		}
		scope: "Namespaced"
		versions: [{
			additionalPrinterColumns: [{
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].message"
				name:     "Status"
				type:     "string"
			}]
			name: "v1"
			schema: openAPIV3Schema: {
				description: "Kustomization is the Schema for the kustomizations API."
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "KustomizationSpec defines the configuration to calculate the desired state from a Source using Kustomize."

						properties: {
							commonMetadata: {
								description: "CommonMetadata specifies the common labels and annotations that are applied to all resources. Any existing label or annotation will be overridden if its key matches a common one."

								properties: {
									annotations: {
										additionalProperties: type: "string"
										description: "Annotations to be added to the object's metadata."
										type:        "object"
									}
									labels: {
										additionalProperties: type: "string"
										description: "Labels to be added to the object's metadata."
										type:        "object"
									}
								}
								type: "object"
							}
							components: {
								description: "Components specifies relative paths to specifications of other Components."

								items: type: "string"
								type: "array"
							}
							decryption: {
								description: "Decrypt Kubernetes secrets before applying them on the cluster."

								properties: {
									provider: {
										description: "Provider is the name of the decryption engine."
										enum: [
											"sops",
										]
										type: "string"
									}
									secretRef: {
										description: "The secret name containing the private OpenPGP keys used for decryption."

										properties: name: {
											description: "Name of the referent."
											type:        "string"
										}
										required: [
											"name",
										]
										type: "object"
									}
								}
								required: [
									"provider",
								]
								type: "object"
							}
							dependsOn: {
								description: "DependsOn may contain a meta.NamespacedObjectReference slice with references to Kustomization resources that must be ready before this Kustomization can be reconciled."

								items: {
									description: "NamespacedObjectReference contains enough information to locate the referenced Kubernetes resource object in any namespace."

									properties: {
										name: {
											description: "Name of the referent."
											type:        "string"
										}
										namespace: {
											description: "Namespace of the referent, when not specified it acts as LocalObjectReference."

											type: "string"
										}
									}
									required: [
										"name",
									]
									type: "object"
								}
								type: "array"
							}
							force: {
								default:     false
								description: "Force instructs the controller to recreate resources when patching fails due to an immutable field change."

								type: "boolean"
							}
							healthChecks: {
								description: "A list of resources to be included in the health assessment."
								items: {
									description: "NamespacedObjectKindReference contains enough information to locate the typed referenced Kubernetes resource object in any namespace."

									properties: {
										apiVersion: {
											description: "API version of the referent, if not specified the Kubernetes preferred version will be used."

											type: "string"
										}
										kind: {
											description: "Kind of the referent."
											type:        "string"
										}
										name: {
											description: "Name of the referent."
											type:        "string"
										}
										namespace: {
											description: "Namespace of the referent, when not specified it acts as LocalObjectReference."

											type: "string"
										}
									}
									required: [
										"kind",
										"name",
									]
									type: "object"
								}
								type: "array"
							}
							images: {
								description: "Images is a list of (image name, new name, new tag or digest) for changing image names, tags or digests. This can also be achieved with a patch, but this operator is simpler to specify."

								items: {
									description: "Image contains an image name, a new name, a new tag or digest, which will replace the original name and tag."

									properties: {
										digest: {
											description: "Digest is the value used to replace the original image tag. If digest is present NewTag value is ignored."

											type: "string"
										}
										name: {
											description: "Name is a tag-less image name."
											type:        "string"
										}
										newName: {
											description: "NewName is the value used to replace the original name."

											type: "string"
										}
										newTag: {
											description: "NewTag is the value used to replace the original tag."

											type: "string"
										}
									}
									required: [
										"name",
									]
									type: "object"
								}
								type: "array"
							}
							interval: {
								description: "The interval at which to reconcile the Kustomization. This interval is approximate and may be subject to jitter to ensure efficient use of resources."

								pattern: "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:    "string"
							}
							kubeConfig: {
								description: "The KubeConfig for reconciling the Kustomization on a remote cluster. When used in combination with KustomizationSpec.ServiceAccountName, forces the controller to act on behalf of that Service Account at the target cluster. If the --default-service-account flag is set, its value will be used as a controller level fallback for when KustomizationSpec.ServiceAccountName is empty."

								properties: secretRef: {
									description: "SecretRef holds the name of a secret that contains a key with the kubeconfig file as the value. If no key is set, the key will default to 'value'. It is recommended that the kubeconfig is self-contained, and the secret is regularly updated if credentials such as a cloud-access-token expire. Cloud specific `cmd-path` auth helpers will not function without adding binaries and credentials to the Pod that is responsible for reconciling Kubernetes resources."

									properties: {
										key: {
											description: "Key in the Secret, when not specified an implementation-specific default key is used."

											type: "string"
										}
										name: {
											description: "Name of the Secret."
											type:        "string"
										}
									}
									required: [
										"name",
									]
									type: "object"
								}
								required: [
									"secretRef",
								]
								type: "object"
							}
							patches: {
								description: "Strategic merge and JSON patches, defined as inline YAML objects, capable of targeting objects based on kind, label and annotation selectors."

								items: {
									description: "Patch contains an inline StrategicMerge or JSON6902 patch, and the target the patch should be applied to."

									properties: {
										patch: {
											description: "Patch contains an inline StrategicMerge patch or an inline JSON6902 patch with an array of operation objects."

											type: "string"
										}
										target: {
											description: "Target points to the resources that the patch document should be applied to."

											properties: {
												annotationSelector: {
													description: "AnnotationSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource annotations."

													type: "string"
												}
												group: {
													description: "Group is the API group to select resources from. Together with Version and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												kind: {
													description: "Kind of the API Group to select resources from. Together with Group and Version it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												labelSelector: {
													description: "LabelSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource labels."

													type: "string"
												}
												name: {
													description: "Name to match resources with."
													type:        "string"
												}
												namespace: {
													description: "Namespace to select resources from."
													type:        "string"
												}
												version: {
													description: "Version of the API Group to select resources from. Together with Group and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
											}
											type: "object"
										}
									}
									required: [
										"patch",
									]
									type: "object"
								}
								type: "array"
							}
							path: {
								description: "Path to the directory containing the kustomization.yaml file, or the set of plain YAMLs a kustomization.yaml should be generated for. Defaults to 'None', which translates to the root path of the SourceRef."

								type: "string"
							}
							postBuild: {
								description: "PostBuild describes which actions to perform on the YAML manifest generated by building the kustomize overlay."

								properties: {
									substitute: {
										additionalProperties: type: "string"
										description: "Substitute holds a map of key/value pairs. The variables defined in your YAML manifests that match any of the keys defined in the map will be substituted with the set value. Includes support for bash string replacement functions e.g. ${var:=default}, ${var:position} and ${var/substring/replacement}."

										type: "object"
									}
									substituteFrom: {
										description: "SubstituteFrom holds references to ConfigMaps and Secrets containing the variables and their values to be substituted in the YAML manifests. The ConfigMap and the Secret data keys represent the var names, and they must match the vars declared in the manifests for the substitution to happen."

										items: {
											description: "SubstituteReference contains a reference to a resource containing the variables name and value."

											properties: {
												kind: {
													description: "Kind of the values referent, valid values are ('Secret', 'ConfigMap')."

													enum: [
														"Secret",
														"ConfigMap",
													]
													type: "string"
												}
												name: {
													description: "Name of the values referent. Should reside in the same namespace as the referring resource."

													maxLength: 253
													minLength: 1
													type:      "string"
												}
												optional: {
													default:     false
													description: "Optional indicates whether the referenced resource must exist, or whether to tolerate its absence. If true and the referenced resource is absent, proceed as if the resource was present but empty, without any variables defined."

													type: "boolean"
												}
											}
											required: [
												"kind",
												"name",
											]
											type: "object"
										}
										type: "array"
									}
								}
								type: "object"
							}
							prune: {
								description: "Prune enables garbage collection."
								type:        "boolean"
							}
							retryInterval: {
								description: "The interval at which to retry a previously failed reconciliation. When not specified, the controller uses the KustomizationSpec.Interval value to retry failures."

								pattern: "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:    "string"
							}
							serviceAccountName: {
								description: "The name of the Kubernetes service account to impersonate when reconciling this Kustomization."

								type: "string"
							}
							sourceRef: {
								description: "Reference of the source where the kustomization file is."

								properties: {
									apiVersion: {
										description: "API version of the referent."
										type:        "string"
									}
									kind: {
										description: "Kind of the referent."
										enum: [
											"OCIRepository",
											"GitRepository",
											"Bucket",
										]
										type: "string"
									}
									name: {
										description: "Name of the referent."
										type:        "string"
									}
									namespace: {
										description: "Namespace of the referent, defaults to the namespace of the Kubernetes resource object that contains the reference."

										type: "string"
									}
								}
								required: [
									"kind",
									"name",
								]
								type: "object"
							}
							suspend: {
								description: "This flag tells the controller to suspend subsequent kustomize executions, it does not apply to already started executions. Defaults to false."

								type: "boolean"
							}
							targetNamespace: {
								description: "TargetNamespace sets or overrides the namespace in the kustomization.yaml file."

								maxLength: 63
								minLength: 1
								type:      "string"
							}
							timeout: {
								description: "Timeout for validation, apply and health checking operations. Defaults to 'Interval' duration."

								pattern: "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:    "string"
							}
							wait: {
								description: "Wait instructs the controller to check the health of all the reconciled resources. When enabled, the HealthChecks are ignored. Defaults to false."

								type: "boolean"
							}
						}
						required: [
							"interval",
							"prune",
							"sourceRef",
						]
						type: "object"
					}
					status: {
						default: observedGeneration: -1
						description: "KustomizationStatus defines the observed state of a kustomization."
						properties: {
							conditions: {
								items: {
									description: """
			Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, 
			 type FooStatus struct{ // Represents the observations of a foo's current state. // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\" // +patchMergeKey=type // +patchStrategy=merge // +listType=map // +listMapKey=type Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` 
			 // other fields }
			"""

									properties: {
										lastTransitionTime: {
											description: "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."

											format: "date-time"
											type:   "string"
										}
										message: {
											description: "message is a human readable message indicating details about the transition. This may be an empty string."

											maxLength: 32768
											type:      "string"
										}
										observedGeneration: {
											description: "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."

											format:  "int64"
											minimum: 0
											type:    "integer"
										}
										reason: {
											description: "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."

											maxLength: 1024
											minLength: 1
											pattern:   "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
											type:      "string"
										}
										status: {
											description: "status of the condition, one of True, False, Unknown."
											enum: [
												"True",
												"False",
												"Unknown",
											]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"

											maxLength: 316
											pattern:   "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:      "string"
										}
									}
									required: [
										"lastTransitionTime",
										"message",
										"reason",
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							inventory: {
								description: "Inventory contains the list of Kubernetes resource object references that have been successfully applied."

								properties: entries: {
									description: "Entries of Kubernetes resource object references."
									items: {
										description: "ResourceRef contains the information necessary to locate a resource within a cluster."

										properties: {
											id: {
												description: "ID is the string representation of the Kubernetes resource object's metadata, in the format '<namespace>_<name>_<group>_<kind>'."

												type: "string"
											}
											v: {
												description: "Version is the API version of the Kubernetes resource object's kind."

												type: "string"
											}
										}
										required: [
											"id",
											"v",
										]
										type: "object"
									}
									type: "array"
								}
								required: [
									"entries",
								]
								type: "object"
							}
							lastAppliedRevision: {
								description: "The last successfully applied revision. Equals the Revision of the applied Artifact from the referenced Source."

								type: "string"
							}
							lastAttemptedRevision: {
								description: "LastAttemptedRevision is the revision of the last reconciliation attempt."

								type: "string"
							}
							lastHandledReconcileAt: {
								description: "LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change of the annotation value can be detected."

								type: "string"
							}
							observedGeneration: {
								description: "ObservedGeneration is the last reconciled generation."
								format:      "int64"
								type:        "integer"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: true
			subresources: status: {}
		}, {
			additionalPrinterColumns: [{
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].message"
				name:     "Status"
				type:     "string"
			}, {
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}]
			deprecated:         true
			deprecationWarning: "v1beta1 Kustomization is deprecated, upgrade to v1"
			name:               "v1beta1"
			schema: openAPIV3Schema: {
				description: "Kustomization is the Schema for the kustomizations API."
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "KustomizationSpec defines the desired state of a kustomization."
						properties: {
							decryption: {
								description: "Decrypt Kubernetes secrets before applying them on the cluster."

								properties: {
									provider: {
										description: "Provider is the name of the decryption engine."
										enum: [
											"sops",
										]
										type: "string"
									}
									secretRef: {
										description: "The secret name containing the private OpenPGP keys used for decryption."

										properties: name: {
											description: "Name of the referent."
											type:        "string"
										}
										required: [
											"name",
										]
										type: "object"
									}
								}
								required: [
									"provider",
								]
								type: "object"
							}
							dependsOn: {
								description: "DependsOn may contain a meta.NamespacedObjectReference slice with references to Kustomization resources that must be ready before this Kustomization can be reconciled."

								items: {
									description: "NamespacedObjectReference contains enough information to locate the referenced Kubernetes resource object in any namespace."

									properties: {
										name: {
											description: "Name of the referent."
											type:        "string"
										}
										namespace: {
											description: "Namespace of the referent, when not specified it acts as LocalObjectReference."

											type: "string"
										}
									}
									required: [
										"name",
									]
									type: "object"
								}
								type: "array"
							}
							force: {
								default:     false
								description: "Force instructs the controller to recreate resources when patching fails due to an immutable field change."

								type: "boolean"
							}
							healthChecks: {
								description: "A list of resources to be included in the health assessment."
								items: {
									description: "NamespacedObjectKindReference contains enough information to locate the typed referenced Kubernetes resource object in any namespace."

									properties: {
										apiVersion: {
											description: "API version of the referent, if not specified the Kubernetes preferred version will be used."

											type: "string"
										}
										kind: {
											description: "Kind of the referent."
											type:        "string"
										}
										name: {
											description: "Name of the referent."
											type:        "string"
										}
										namespace: {
											description: "Namespace of the referent, when not specified it acts as LocalObjectReference."

											type: "string"
										}
									}
									required: [
										"kind",
										"name",
									]
									type: "object"
								}
								type: "array"
							}
							images: {
								description: "Images is a list of (image name, new name, new tag or digest) for changing image names, tags or digests. This can also be achieved with a patch, but this operator is simpler to specify."

								items: {
									description: "Image contains an image name, a new name, a new tag or digest, which will replace the original name and tag."

									properties: {
										digest: {
											description: "Digest is the value used to replace the original image tag. If digest is present NewTag value is ignored."

											type: "string"
										}
										name: {
											description: "Name is a tag-less image name."
											type:        "string"
										}
										newName: {
											description: "NewName is the value used to replace the original name."

											type: "string"
										}
										newTag: {
											description: "NewTag is the value used to replace the original tag."

											type: "string"
										}
									}
									required: [
										"name",
									]
									type: "object"
								}
								type: "array"
							}
							interval: {
								description: "The interval at which to reconcile the Kustomization."
								type:        "string"
							}
							kubeConfig: {
								description: "The KubeConfig for reconciling the Kustomization on a remote cluster. When specified, KubeConfig takes precedence over ServiceAccountName."

								properties: secretRef: {
									description: "SecretRef holds the name to a secret that contains a 'value' key with the kubeconfig file as the value. It must be in the same namespace as the Kustomization. It is recommended that the kubeconfig is self-contained, and the secret is regularly updated if credentials such as a cloud-access-token expire. Cloud specific `cmd-path` auth helpers will not function without adding binaries and credentials to the Pod that is responsible for reconciling the Kustomization."

									properties: name: {
										description: "Name of the referent."
										type:        "string"
									}
									required: [
										"name",
									]
									type: "object"
								}
								type: "object"
							}
							patches: {
								description: "Strategic merge and JSON patches, defined as inline YAML objects, capable of targeting objects based on kind, label and annotation selectors."

								items: {
									description: "Patch contains an inline StrategicMerge or JSON6902 patch, and the target the patch should be applied to."

									properties: {
										patch: {
											description: "Patch contains an inline StrategicMerge patch or an inline JSON6902 patch with an array of operation objects."

											type: "string"
										}
										target: {
											description: "Target points to the resources that the patch document should be applied to."

											properties: {
												annotationSelector: {
													description: "AnnotationSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource annotations."

													type: "string"
												}
												group: {
													description: "Group is the API group to select resources from. Together with Version and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												kind: {
													description: "Kind of the API Group to select resources from. Together with Group and Version it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												labelSelector: {
													description: "LabelSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource labels."

													type: "string"
												}
												name: {
													description: "Name to match resources with."
													type:        "string"
												}
												namespace: {
													description: "Namespace to select resources from."
													type:        "string"
												}
												version: {
													description: "Version of the API Group to select resources from. Together with Group and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
											}
											type: "object"
										}
									}
									required: [
										"patch",
									]
									type: "object"
								}
								type: "array"
							}
							patchesJson6902: {
								description: "JSON 6902 patches, defined as inline YAML objects."
								items: {
									description: "JSON6902Patch contains a JSON6902 patch and the target the patch should be applied to."

									properties: {
										patch: {
											description: "Patch contains the JSON6902 patch document with an array of operation objects."

											items: {
												description: "JSON6902 is a JSON6902 operation object. https://datatracker.ietf.org/doc/html/rfc6902#section-4"
												properties: {
													from: {
														description: "From contains a JSON-pointer value that references a location within the target document where the operation is performed. The meaning of the value depends on the value of Op, and is NOT taken into account by all operations."

														type: "string"
													}
													op: {
														description: "Op indicates the operation to perform. Its value MUST be one of \"add\", \"remove\", \"replace\", \"move\", \"copy\", or \"test\". https://datatracker.ietf.org/doc/html/rfc6902#section-4"

														enum: [
															"test",
															"remove",
															"add",
															"replace",
															"move",
															"copy",
														]
														type: "string"
													}
													path: {
														description: "Path contains the JSON-pointer value that references a location within the target document where the operation is performed. The meaning of the value depends on the value of Op."

														type: "string"
													}
													value: {
														description: "Value contains a valid JSON structure. The meaning of the value depends on the value of Op, and is NOT taken into account by all operations."

														"x-kubernetes-preserve-unknown-fields": true
													}
												}
												required: [
													"op",
													"path",
												]
												type: "object"
											}
											type: "array"
										}
										target: {
											description: "Target points to the resources that the patch document should be applied to."

											properties: {
												annotationSelector: {
													description: "AnnotationSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource annotations."

													type: "string"
												}
												group: {
													description: "Group is the API group to select resources from. Together with Version and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												kind: {
													description: "Kind of the API Group to select resources from. Together with Group and Version it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												labelSelector: {
													description: "LabelSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource labels."

													type: "string"
												}
												name: {
													description: "Name to match resources with."
													type:        "string"
												}
												namespace: {
													description: "Namespace to select resources from."
													type:        "string"
												}
												version: {
													description: "Version of the API Group to select resources from. Together with Group and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
											}
											type: "object"
										}
									}
									required: [
										"patch",
										"target",
									]
									type: "object"
								}
								type: "array"
							}
							patchesStrategicMerge: {
								description: "Strategic merge patches, defined as inline YAML objects."
								items: "x-kubernetes-preserve-unknown-fields": true
								type: "array"
							}
							path: {
								description: "Path to the directory containing the kustomization.yaml file, or the set of plain YAMLs a kustomization.yaml should be generated for. Defaults to 'None', which translates to the root path of the SourceRef."

								type: "string"
							}
							postBuild: {
								description: "PostBuild describes which actions to perform on the YAML manifest generated by building the kustomize overlay."

								properties: {
									substitute: {
										additionalProperties: type: "string"
										description: "Substitute holds a map of key/value pairs. The variables defined in your YAML manifests that match any of the keys defined in the map will be substituted with the set value. Includes support for bash string replacement functions e.g. ${var:=default}, ${var:position} and ${var/substring/replacement}."

										type: "object"
									}
									substituteFrom: {
										description: "SubstituteFrom holds references to ConfigMaps and Secrets containing the variables and their values to be substituted in the YAML manifests. The ConfigMap and the Secret data keys represent the var names and they must match the vars declared in the manifests for the substitution to happen."

										items: {
											description: "SubstituteReference contains a reference to a resource containing the variables name and value."

											properties: {
												kind: {
													description: "Kind of the values referent, valid values are ('Secret', 'ConfigMap')."

													enum: [
														"Secret",
														"ConfigMap",
													]
													type: "string"
												}
												name: {
													description: "Name of the values referent. Should reside in the same namespace as the referring resource."

													maxLength: 253
													minLength: 1
													type:      "string"
												}
											}
											required: [
												"kind",
												"name",
											]
											type: "object"
										}
										type: "array"
									}
								}
								type: "object"
							}
							prune: {
								description: "Prune enables garbage collection."
								type:        "boolean"
							}
							retryInterval: {
								description: "The interval at which to retry a previously failed reconciliation. When not specified, the controller uses the KustomizationSpec.Interval value to retry failures."

								type: "string"
							}
							serviceAccountName: {
								description: "The name of the Kubernetes service account to impersonate when reconciling this Kustomization."

								type: "string"
							}
							sourceRef: {
								description: "Reference of the source where the kustomization file is."

								properties: {
									apiVersion: {
										description: "API version of the referent"
										type:        "string"
									}
									kind: {
										description: "Kind of the referent"
										enum: [
											"GitRepository",
											"Bucket",
										]
										type: "string"
									}
									name: {
										description: "Name of the referent"
										type:        "string"
									}
									namespace: {
										description: "Namespace of the referent, defaults to the Kustomization namespace"

										type: "string"
									}
								}
								required: [
									"kind",
									"name",
								]
								type: "object"
							}
							suspend: {
								description: "This flag tells the controller to suspend subsequent kustomize executions, it does not apply to already started executions. Defaults to false."

								type: "boolean"
							}
							targetNamespace: {
								description: "TargetNamespace sets or overrides the namespace in the kustomization.yaml file."

								maxLength: 63
								minLength: 1
								type:      "string"
							}
							timeout: {
								description: "Timeout for validation, apply and health checking operations. Defaults to 'Interval' duration."

								type: "string"
							}
							validation: {
								description: "Validate the Kubernetes objects before applying them on the cluster. The validation strategy can be 'client' (local dry-run), 'server' (APIServer dry-run) or 'none'. When 'Force' is 'true', validation will fallback to 'client' if set to 'server' because server-side validation is not supported in this scenario."

								enum: [
									"none",
									"client",
									"server",
								]
								type: "string"
							}
						}
						required: [
							"interval",
							"prune",
							"sourceRef",
						]
						type: "object"
					}
					status: {
						default: observedGeneration: -1
						description: "KustomizationStatus defines the observed state of a kustomization."
						properties: {
							conditions: {
								items: {
									description: """
			Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, 
			 type FooStatus struct{ // Represents the observations of a foo's current state. // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\" // +patchMergeKey=type // +patchStrategy=merge // +listType=map // +listMapKey=type Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` 
			 // other fields }
			"""

									properties: {
										lastTransitionTime: {
											description: "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."

											format: "date-time"
											type:   "string"
										}
										message: {
											description: "message is a human readable message indicating details about the transition. This may be an empty string."

											maxLength: 32768
											type:      "string"
										}
										observedGeneration: {
											description: "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."

											format:  "int64"
											minimum: 0
											type:    "integer"
										}
										reason: {
											description: "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."

											maxLength: 1024
											minLength: 1
											pattern:   "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
											type:      "string"
										}
										status: {
											description: "status of the condition, one of True, False, Unknown."
											enum: [
												"True",
												"False",
												"Unknown",
											]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"

											maxLength: 316
											pattern:   "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:      "string"
										}
									}
									required: [
										"lastTransitionTime",
										"message",
										"reason",
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							lastAppliedRevision: {
								description: "The last successfully applied revision. The revision format for Git sources is <branch|tag>/<commit-sha>."

								type: "string"
							}
							lastAttemptedRevision: {
								description: "LastAttemptedRevision is the revision of the last reconciliation attempt."

								type: "string"
							}
							lastHandledReconcileAt: {
								description: "LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change of the annotation value can be detected."

								type: "string"
							}
							observedGeneration: {
								description: "ObservedGeneration is the last reconciled generation."
								format:      "int64"
								type:        "integer"
							}
							snapshot: {
								description: "The last successfully applied revision metadata."
								properties: {
									checksum: {
										description: "The manifests sha1 checksum."
										type:        "string"
									}
									entries: {
										description: "A list of Kubernetes kinds grouped by namespace."
										items: {
											description: "Snapshot holds the metadata of namespaced Kubernetes objects"

											properties: {
												kinds: {
													additionalProperties: type: "string"
													description: "The list of Kubernetes kinds."
													type:        "object"
												}
												namespace: {
													description: "The namespace of this entry."
													type:        "string"
												}
											}
											required: [
												"kinds",
											]
											type: "object"
										}
										type: "array"
									}
								}
								required: [
									"checksum",
									"entries",
								]
								type: "object"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: false
			subresources: status: {}
		}, {
			additionalPrinterColumns: [{
				jsonPath: ".metadata.creationTimestamp"
				name:     "Age"
				type:     "date"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].status"
				name:     "Ready"
				type:     "string"
			}, {
				jsonPath: ".status.conditions[?(@.type==\"Ready\")].message"
				name:     "Status"
				type:     "string"
			}]
			deprecated:         true
			deprecationWarning: "v1beta2 Kustomization is deprecated, upgrade to v1"
			name:               "v1beta2"
			schema: openAPIV3Schema: {
				description: "Kustomization is the Schema for the kustomizations API."
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "KustomizationSpec defines the configuration to calculate the desired state from a Source using Kustomize."

						properties: {
							commonMetadata: {
								description: "CommonMetadata specifies the common labels and annotations that are applied to all resources. Any existing label or annotation will be overridden if its key matches a common one."

								properties: {
									annotations: {
										additionalProperties: type: "string"
										description: "Annotations to be added to the object's metadata."
										type:        "object"
									}
									labels: {
										additionalProperties: type: "string"
										description: "Labels to be added to the object's metadata."
										type:        "object"
									}
								}
								type: "object"
							}
							components: {
								description: "Components specifies relative paths to specifications of other Components."

								items: type: "string"
								type: "array"
							}
							decryption: {
								description: "Decrypt Kubernetes secrets before applying them on the cluster."

								properties: {
									provider: {
										description: "Provider is the name of the decryption engine."
										enum: [
											"sops",
										]
										type: "string"
									}
									secretRef: {
										description: "The secret name containing the private OpenPGP keys used for decryption."

										properties: name: {
											description: "Name of the referent."
											type:        "string"
										}
										required: [
											"name",
										]
										type: "object"
									}
								}
								required: [
									"provider",
								]
								type: "object"
							}
							dependsOn: {
								description: "DependsOn may contain a meta.NamespacedObjectReference slice with references to Kustomization resources that must be ready before this Kustomization can be reconciled."

								items: {
									description: "NamespacedObjectReference contains enough information to locate the referenced Kubernetes resource object in any namespace."

									properties: {
										name: {
											description: "Name of the referent."
											type:        "string"
										}
										namespace: {
											description: "Namespace of the referent, when not specified it acts as LocalObjectReference."

											type: "string"
										}
									}
									required: [
										"name",
									]
									type: "object"
								}
								type: "array"
							}
							force: {
								default:     false
								description: "Force instructs the controller to recreate resources when patching fails due to an immutable field change."

								type: "boolean"
							}
							healthChecks: {
								description: "A list of resources to be included in the health assessment."
								items: {
									description: "NamespacedObjectKindReference contains enough information to locate the typed referenced Kubernetes resource object in any namespace."

									properties: {
										apiVersion: {
											description: "API version of the referent, if not specified the Kubernetes preferred version will be used."

											type: "string"
										}
										kind: {
											description: "Kind of the referent."
											type:        "string"
										}
										name: {
											description: "Name of the referent."
											type:        "string"
										}
										namespace: {
											description: "Namespace of the referent, when not specified it acts as LocalObjectReference."

											type: "string"
										}
									}
									required: [
										"kind",
										"name",
									]
									type: "object"
								}
								type: "array"
							}
							images: {
								description: "Images is a list of (image name, new name, new tag or digest) for changing image names, tags or digests. This can also be achieved with a patch, but this operator is simpler to specify."

								items: {
									description: "Image contains an image name, a new name, a new tag or digest, which will replace the original name and tag."

									properties: {
										digest: {
											description: "Digest is the value used to replace the original image tag. If digest is present NewTag value is ignored."

											type: "string"
										}
										name: {
											description: "Name is a tag-less image name."
											type:        "string"
										}
										newName: {
											description: "NewName is the value used to replace the original name."

											type: "string"
										}
										newTag: {
											description: "NewTag is the value used to replace the original tag."

											type: "string"
										}
									}
									required: [
										"name",
									]
									type: "object"
								}
								type: "array"
							}
							interval: {
								description: "The interval at which to reconcile the Kustomization."
								pattern:     "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:        "string"
							}
							kubeConfig: {
								description: "The KubeConfig for reconciling the Kustomization on a remote cluster. When used in combination with KustomizationSpec.ServiceAccountName, forces the controller to act on behalf of that Service Account at the target cluster. If the --default-service-account flag is set, its value will be used as a controller level fallback for when KustomizationSpec.ServiceAccountName is empty."

								properties: secretRef: {
									description: "SecretRef holds the name of a secret that contains a key with the kubeconfig file as the value. If no key is set, the key will default to 'value'. It is recommended that the kubeconfig is self-contained, and the secret is regularly updated if credentials such as a cloud-access-token expire. Cloud specific `cmd-path` auth helpers will not function without adding binaries and credentials to the Pod that is responsible for reconciling Kubernetes resources."

									properties: {
										key: {
											description: "Key in the Secret, when not specified an implementation-specific default key is used."

											type: "string"
										}
										name: {
											description: "Name of the Secret."
											type:        "string"
										}
									}
									required: [
										"name",
									]
									type: "object"
								}
								required: [
									"secretRef",
								]
								type: "object"
							}
							patches: {
								description: "Strategic merge and JSON patches, defined as inline YAML objects, capable of targeting objects based on kind, label and annotation selectors."

								items: {
									description: "Patch contains an inline StrategicMerge or JSON6902 patch, and the target the patch should be applied to."

									properties: {
										patch: {
											description: "Patch contains an inline StrategicMerge patch or an inline JSON6902 patch with an array of operation objects."

											type: "string"
										}
										target: {
											description: "Target points to the resources that the patch document should be applied to."

											properties: {
												annotationSelector: {
													description: "AnnotationSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource annotations."

													type: "string"
												}
												group: {
													description: "Group is the API group to select resources from. Together with Version and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												kind: {
													description: "Kind of the API Group to select resources from. Together with Group and Version it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												labelSelector: {
													description: "LabelSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource labels."

													type: "string"
												}
												name: {
													description: "Name to match resources with."
													type:        "string"
												}
												namespace: {
													description: "Namespace to select resources from."
													type:        "string"
												}
												version: {
													description: "Version of the API Group to select resources from. Together with Group and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
											}
											type: "object"
										}
									}
									required: [
										"patch",
									]
									type: "object"
								}
								type: "array"
							}
							patchesJson6902: {
								description: "JSON 6902 patches, defined as inline YAML objects. Deprecated: Use Patches instead."

								items: {
									description: "JSON6902Patch contains a JSON6902 patch and the target the patch should be applied to."

									properties: {
										patch: {
											description: "Patch contains the JSON6902 patch document with an array of operation objects."

											items: {
												description: "JSON6902 is a JSON6902 operation object. https://datatracker.ietf.org/doc/html/rfc6902#section-4"
												properties: {
													from: {
														description: "From contains a JSON-pointer value that references a location within the target document where the operation is performed. The meaning of the value depends on the value of Op, and is NOT taken into account by all operations."

														type: "string"
													}
													op: {
														description: "Op indicates the operation to perform. Its value MUST be one of \"add\", \"remove\", \"replace\", \"move\", \"copy\", or \"test\". https://datatracker.ietf.org/doc/html/rfc6902#section-4"

														enum: [
															"test",
															"remove",
															"add",
															"replace",
															"move",
															"copy",
														]
														type: "string"
													}
													path: {
														description: "Path contains the JSON-pointer value that references a location within the target document where the operation is performed. The meaning of the value depends on the value of Op."

														type: "string"
													}
													value: {
														description: "Value contains a valid JSON structure. The meaning of the value depends on the value of Op, and is NOT taken into account by all operations."

														"x-kubernetes-preserve-unknown-fields": true
													}
												}
												required: [
													"op",
													"path",
												]
												type: "object"
											}
											type: "array"
										}
										target: {
											description: "Target points to the resources that the patch document should be applied to."

											properties: {
												annotationSelector: {
													description: "AnnotationSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource annotations."

													type: "string"
												}
												group: {
													description: "Group is the API group to select resources from. Together with Version and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												kind: {
													description: "Kind of the API Group to select resources from. Together with Group and Version it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
												labelSelector: {
													description: "LabelSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches with the resource labels."

													type: "string"
												}
												name: {
													description: "Name to match resources with."
													type:        "string"
												}
												namespace: {
													description: "Namespace to select resources from."
													type:        "string"
												}
												version: {
													description: "Version of the API Group to select resources from. Together with Group and Kind it is capable of unambiguously identifying and/or selecting resources. https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/api-group.md"

													type: "string"
												}
											}
											type: "object"
										}
									}
									required: [
										"patch",
										"target",
									]
									type: "object"
								}
								type: "array"
							}
							patchesStrategicMerge: {
								description: "Strategic merge patches, defined as inline YAML objects. Deprecated: Use Patches instead."

								items: "x-kubernetes-preserve-unknown-fields": true
								type: "array"
							}
							path: {
								description: "Path to the directory containing the kustomization.yaml file, or the set of plain YAMLs a kustomization.yaml should be generated for. Defaults to 'None', which translates to the root path of the SourceRef."

								type: "string"
							}
							postBuild: {
								description: "PostBuild describes which actions to perform on the YAML manifest generated by building the kustomize overlay."

								properties: {
									substitute: {
										additionalProperties: type: "string"
										description: "Substitute holds a map of key/value pairs. The variables defined in your YAML manifests that match any of the keys defined in the map will be substituted with the set value. Includes support for bash string replacement functions e.g. ${var:=default}, ${var:position} and ${var/substring/replacement}."

										type: "object"
									}
									substituteFrom: {
										description: "SubstituteFrom holds references to ConfigMaps and Secrets containing the variables and their values to be substituted in the YAML manifests. The ConfigMap and the Secret data keys represent the var names and they must match the vars declared in the manifests for the substitution to happen."

										items: {
											description: "SubstituteReference contains a reference to a resource containing the variables name and value."

											properties: {
												kind: {
													description: "Kind of the values referent, valid values are ('Secret', 'ConfigMap')."

													enum: [
														"Secret",
														"ConfigMap",
													]
													type: "string"
												}
												name: {
													description: "Name of the values referent. Should reside in the same namespace as the referring resource."

													maxLength: 253
													minLength: 1
													type:      "string"
												}
												optional: {
													default:     false
													description: "Optional indicates whether the referenced resource must exist, or whether to tolerate its absence. If true and the referenced resource is absent, proceed as if the resource was present but empty, without any variables defined."

													type: "boolean"
												}
											}
											required: [
												"kind",
												"name",
											]
											type: "object"
										}
										type: "array"
									}
								}
								type: "object"
							}
							prune: {
								description: "Prune enables garbage collection."
								type:        "boolean"
							}
							retryInterval: {
								description: "The interval at which to retry a previously failed reconciliation. When not specified, the controller uses the KustomizationSpec.Interval value to retry failures."

								pattern: "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:    "string"
							}
							serviceAccountName: {
								description: "The name of the Kubernetes service account to impersonate when reconciling this Kustomization."

								type: "string"
							}
							sourceRef: {
								description: "Reference of the source where the kustomization file is."

								properties: {
									apiVersion: {
										description: "API version of the referent."
										type:        "string"
									}
									kind: {
										description: "Kind of the referent."
										enum: [
											"OCIRepository",
											"GitRepository",
											"Bucket",
										]
										type: "string"
									}
									name: {
										description: "Name of the referent."
										type:        "string"
									}
									namespace: {
										description: "Namespace of the referent, defaults to the namespace of the Kubernetes resource object that contains the reference."

										type: "string"
									}
								}
								required: [
									"kind",
									"name",
								]
								type: "object"
							}
							suspend: {
								description: "This flag tells the controller to suspend subsequent kustomize executions, it does not apply to already started executions. Defaults to false."

								type: "boolean"
							}
							targetNamespace: {
								description: "TargetNamespace sets or overrides the namespace in the kustomization.yaml file."

								maxLength: 63
								minLength: 1
								type:      "string"
							}
							timeout: {
								description: "Timeout for validation, apply and health checking operations. Defaults to 'Interval' duration."

								pattern: "^([0-9]+(\\.[0-9]+)?(ms|s|m|h))+$"
								type:    "string"
							}
							validation: {
								description: "Deprecated: Not used in v1beta2."
								enum: [
									"none",
									"client",
									"server",
								]
								type: "string"
							}
							wait: {
								description: "Wait instructs the controller to check the health of all the reconciled resources. When enabled, the HealthChecks are ignored. Defaults to false."

								type: "boolean"
							}
						}
						required: [
							"interval",
							"prune",
							"sourceRef",
						]
						type: "object"
					}
					status: {
						default: observedGeneration: -1
						description: "KustomizationStatus defines the observed state of a kustomization."
						properties: {
							conditions: {
								items: {
									description: """
			Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, 
			 type FooStatus struct{ // Represents the observations of a foo's current state. // Known .status.conditions.type are: \"Available\", \"Progressing\", and \"Degraded\" // +patchMergeKey=type // +patchStrategy=merge // +listType=map // +listMapKey=type Conditions []metav1.Condition `json:\"conditions,omitempty\" patchStrategy:\"merge\" patchMergeKey:\"type\" protobuf:\"bytes,1,rep,name=conditions\"` 
			 // other fields }
			"""

									properties: {
										lastTransitionTime: {
											description: "lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable."

											format: "date-time"
											type:   "string"
										}
										message: {
											description: "message is a human readable message indicating details about the transition. This may be an empty string."

											maxLength: 32768
											type:      "string"
										}
										observedGeneration: {
											description: "observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance."

											format:  "int64"
											minimum: 0
											type:    "integer"
										}
										reason: {
											description: "reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty."

											maxLength: 1024
											minLength: 1
											pattern:   "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
											type:      "string"
										}
										status: {
											description: "status of the condition, one of True, False, Unknown."
											enum: [
												"True",
												"False",
												"Unknown",
											]
											type: "string"
										}
										type: {
											description: "type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)"

											maxLength: 316
											pattern:   "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
											type:      "string"
										}
									}
									required: [
										"lastTransitionTime",
										"message",
										"reason",
										"status",
										"type",
									]
									type: "object"
								}
								type: "array"
							}
							inventory: {
								description: "Inventory contains the list of Kubernetes resource object references that have been successfully applied."

								properties: entries: {
									description: "Entries of Kubernetes resource object references."
									items: {
										description: "ResourceRef contains the information necessary to locate a resource within a cluster."

										properties: {
											id: {
												description: "ID is the string representation of the Kubernetes resource object's metadata, in the format '<namespace>_<name>_<group>_<kind>'."

												type: "string"
											}
											v: {
												description: "Version is the API version of the Kubernetes resource object's kind."

												type: "string"
											}
										}
										required: [
											"id",
											"v",
										]
										type: "object"
									}
									type: "array"
								}
								required: [
									"entries",
								]
								type: "object"
							}
							lastAppliedRevision: {
								description: "The last successfully applied revision. Equals the Revision of the applied Artifact from the referenced Source."

								type: "string"
							}
							lastAttemptedRevision: {
								description: "LastAttemptedRevision is the revision of the last reconciliation attempt."

								type: "string"
							}
							lastHandledReconcileAt: {
								description: "LastHandledReconcileAt holds the value of the most recent reconcile request value, so a change of the annotation value can be detected."

								type: "string"
							}
							observedGeneration: {
								description: "ObservedGeneration is the last reconciled generation."
								format:      "int64"
								type:        "integer"
							}
						}
						type: "object"
					}
				}
				type: "object"
			}
			served:  true
			storage: false
			subresources: status: {}
		}]
	}
}
