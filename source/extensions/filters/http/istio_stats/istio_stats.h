// Copyright Istio Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma once

#include "envoy/server/filter_config.h"
#include "envoy/stream_info/filter_state.h"
#include "source/extensions/filters/http/istio_stats/config.pb.h"

namespace Envoy {
namespace Extensions {
namespace HttpFilters {
namespace IstioStats {

class IstioStatsFilterConfigFactory : public Server::Configuration::NamedHttpFilterConfigFactory {
public:
  std::string name() const override { return "envoy.filters.http.istio_stats"; }

  ProtobufTypes::MessagePtr createEmptyConfigProto() override {
    return std::make_unique<stats::PluginConfig>();
  }

  absl::StatusOr<Http::FilterFactoryCb>
  createFilterFactoryFromProto(const Protobuf::Message& proto_config, const std::string&,
                               Server::Configuration::FactoryContext&) override;
};

class IstioStatsNetworkFilterConfigFactory
    : public Server::Configuration::NamedNetworkFilterConfigFactory {
public:
  std::string name() const override { return "envoy.filters.network.istio_stats"; }

  ProtobufTypes::MessagePtr createEmptyConfigProto() override {
    return std::make_unique<stats::PluginConfig>();
  }

  absl::StatusOr<Network::FilterFactoryCb>
  createFilterFactoryFromProto(const Protobuf::Message& proto_config,
                               Server::Configuration::FactoryContext& factory_context) override;
};

} // namespace IstioStats
} // namespace HttpFilters
} // namespace Extensions
} // namespace Envoy
